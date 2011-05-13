/* debugger helper, I keep it here handy */
#define sdump(L, str) printf("\e[32m"); stackDump(L); printf("\e[0m"); printf((str)); printf(".\n");
static void stackDump (lua_State *L) {
  int i;
  int top = lua_gettop(L);
  for (i = 1; i <= top; i++) { /* repeat for each level */
    int t = lua_type(L, i);
    switch (t) {
    case LUA_TSTRING:  printf("'%s'", lua_tostring(L, i));             break;
    case LUA_TBOOLEAN: printf(lua_toboolean(L, i) ? "true" : "false"); break;
    case LUA_TNUMBER:  printf("%g", lua_tonumber(L, i));               break;
    default:           printf("%s", lua_typename(L, t));               break;
    }
    printf("\t"); /* put a separator */
  }
}
