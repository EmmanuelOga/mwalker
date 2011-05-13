#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

/********************************************************************************/

#define SUBSEQ_FOUND (-2) // defined as -2 so when passed to the lua side it will show up as -1.
static inline int ssmatch(const char *str, size_t lstr, const char *subseq, size_t lsubseq, int idx) {
  if (!lstr || !lsubseq || idx >= (int)lsubseq) { return SUBSEQ_FOUND; }

  const char *p = subseq;

  if (idx > 0) p += idx;
  char s, ss = *p;

  while((s = *str++)) {
    if (s == ss && !(ss = *++p)) {
      return SUBSEQ_FOUND;
    };
  }

  return p - subseq;
}

static inline int l_ssmatch(lua_State *L) {
  int match = SUBSEQ_FOUND;
  size_t lstr, lsubseq;
  const char *str = luaL_checklstring(L, 2, &lstr), *subseq = luaL_checklstring(L, 1, &lsubseq);

  if (lstr && lsubseq) {
    int n = luaL_optint(L, 3, 1);
    if (n != -1) { match = ssmatch(str, lstr, subseq, lsubseq, n - 1); }
  }

  lua_pushnumber(L, match + 1);

  return 1;
}

/********************************************************************************/

// return the extension of the base name.
static const char *pathext(const char *basename) {
  size_t len = strlen(basename);
  const char *pend = basename + len;
  const char *p = pend;
  while(p != basename) { if (*p == '.') return p + 1; p--; }
  return pend;
}

static inline void fillTree(lua_State *L, char *pathbuf, size_t origpathbuflen, size_t *total, size_t treefileslimit, size_t recurlimit, int checks, size_t level) {
  lua_newtable(L);

  lua_pushstring(L, "base"); lua_pushstring(L, pathbuf + origpathbuflen); lua_rawset(L, -3);
  lua_pushstring(L, "files"); lua_newtable(L); lua_rawset(L, -3);
  lua_pushstring(L, "dirs"); lua_newtable(L); lua_rawset(L, -3);

  if (level > recurlimit) { return; }

  DIR *d = opendir(pathbuf);

  if (d) {
    size_t files = 0, dirs = 0, curbaselen = strlen(pathbuf);
    struct dirent *entry;
    size_t entries = 0; while ((entry = readdir(d))) entries++;

    if (entries < treefileslimit) {
      rewinddir(d);

      lua_pushstring(L, "files"); lua_rawget(L, -2);
      lua_pushstring(L, "dirs"); lua_rawget(L, -3);

      while ((entry = readdir(d))) {
        char *name = entry-> d_name;
        char c1 = name[0], c2 = name[1];

        if (!(c1 == '.' && (!c2 || (c2 == '.' && !name[2])))) {
          int skipEntry = 0;

          if (checks) {
            const char *current = pathbuf + origpathbuflen;
            if (*current) ++current; // skip initial slash.
            lua_pushvalue(L, 1);
            lua_pushstring(L, current);
            lua_pushstring(L, name);
            const char *ext = pathext(name);
            if (*ext) { lua_pushstring(L, ext); } else { lua_pushnil(L); };
            lua_call(L, 3, 1);
            skipEntry = lua_toboolean(L, -1);
            lua_pop(L, 1);
          }

          if (skipEntry == 0) {
            pathbuf[curbaselen] = '/';
            pathbuf[curbaselen + 1] = 0;
            strcat(pathbuf, name);

            struct stat s;
            if (lstat(pathbuf, &s) != -1) {
              if (S_ISDIR(s.st_mode)) {
                fillTree(L, pathbuf, origpathbuflen, total, treefileslimit, recurlimit, checks, level + 1);
                lua_pushstring(L, "name"); lua_pushstring(L, name); lua_rawset(L, -3);
                lua_rawseti(L, -2, ++dirs);
              } else {
                (*total)++;
                lua_pushstring(L, name);
                lua_rawseti(L, -3, ++files);
              }
            }

            pathbuf[curbaselen] = 0;
          }
        }
      }

      lua_pop(L, 2);
      closedir(d);
    }
  }
};

static inline int l_tree(lua_State *L) {
  int nopts = lua_gettop(L), checks = 0;
  luaL_checktype(L, 1, LUA_TSTRING);
  if (nopts >= 2) { luaL_checktype(L, 2, LUA_TFUNCTION); checks++; }
  if (nopts >= 4) luaL_checktype(L, 3, LUA_TNUMBER);
  if (nopts >= 5) luaL_checktype(L, 4, LUA_TNUMBER);

  size_t total = 0;
  size_t treefileslimit = luaL_optnumber(L, 3, 1024);
  size_t recurlimit = luaL_optnumber(L, 4, 16);

  size_t lpath;
  const char *path = luaL_checklstring(L, 1, &lpath);

  char pathbuf[FILENAME_MAX];

  if (path[lpath - 1] == '/') {
    strncpy(pathbuf, path, lpath - 1);
  } else {
    strcpy(pathbuf, path);
  }

  lua_remove(L, 1);

  fillTree(L, pathbuf, strlen(pathbuf), &total, treefileslimit, recurlimit, checks, 1);

  lua_pushstring(L, "base"); lua_pushstring(L, pathbuf); lua_rawset(L, -3);
  lua_pushstring(L, "size"); lua_pushnumber(L, total); lua_rawset(L, -3);

  return 1;
}

/********************************************************************************/

static inline int l_isdirectory(lua_State *L) {
  size_t lpath;
  const char *path = luaL_checklstring(L, 1, &lpath);

  struct stat s;
  lua_pushboolean(L, (lpath > 0) && (lstat(path, &s) != -1) && S_ISDIR(s.st_mode));

  return 1;
}

static inline int l_isfile(lua_State *L) {
  size_t lpath;
  const char *path = luaL_checklstring(L, 1, &lpath);

  struct stat s;
  lua_pushboolean(L, (lpath > 0) && (lstat(path, &s) != -1) && S_ISREG(s.st_mode));

  return 1;
}

/********************************************************************************/

static const struct luaL_Reg mwalker [] = {
  {"tree", l_tree},
  {"isdirectory", l_isdirectory},
  {"isfile", l_isfile},
  {"ssmatch", l_ssmatch},
  {NULL, NULL} /* sentinel */
};

int luaopen_mwalker(lua_State *L) {
  luaL_register(L, "mwalker", mwalker);
  return 1;
}
