#include <stdlib.h>
#include <stdio.h>

#include <vedis.h>

#define EXEC_CMD(vds_CMD) \
  do { \
    printf("vedis> %s\n", (vds_CMD)); \
    rc = vedis_exec(store, (vds_CMD), -1); \
    if (rc != VEDIS_OK) goto err; \
    rc = vedis_exec_result(store, &res); \
    if (rc != VEDIS_OK) goto err; \
    const char *vds_MSG; \
    if (vedis_value_is_null(res)) { \
      vds_MSG = "(nil)"; \
    } \
    else { \
      vds_MSG = vedis_value_to_string(res, NULL); \
    } \
    printf("%s\n", vds_MSG); \
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
  EXEC_CMD("GET misc");
  EXEC_CMD("SET misc smthg");
  EXEC_CMD("GET misc");

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
