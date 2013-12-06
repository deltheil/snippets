#include <stdlib.h>
#include <stdio.h>

#include <vedis.h>

#define EXEC_CMD(_CMD) \
  do { \
    printf("vedis> %s\n", (_CMD)); \
    rc = vedis_exec(store, (_CMD), -1); \
    if (rc != VEDIS_OK) goto err; \
    rc = vedis_exec_result(store, &res); \
    if (rc != VEDIS_OK) goto err; \
    int _LEN; \
    const char *_MSG = vedis_value_to_string(res, &_LEN); \
    printf("%s\n", _LEN > 0 ? _MSG : "OK"); \
  } while (0)

int
main(int argc, const char **argv)
{
  int rc;
  vedis *store = NULL;
  vedis_value *res = NULL;
  rc = vedis_open(&store, NULL /* in memory */);
  if (rc != VEDIS_OK) goto err;

  EXEC_CMD("HSET props scm git");
  EXEC_CMD("HSET props os linux");
  EXEC_CMD("HLEN props");
  EXEC_CMD("HGETALL props");

  vedis_close(store);
  return 0;

err:
  fprintf(stderr, "error: %d\n", rc);
  if (store) {
    const char *err;
    int len = 0;
    vedis_config(store, VEDIS_CONFIG_ERR_LOG, &err, &len);
    if (len > 0) fprintf(stderr, "%s", err);
    vedis_close(store);
  }
  vedis_lib_shutdown();
  return 1;
}
