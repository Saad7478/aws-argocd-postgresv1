#!/usr/bin/env python3
import urllib.request, sys, os

SEUIL = 85.0
CLUSTER = os.getenv("CLUSTER_NAME", "pg-cluster")
URL = f"http://{CLUSTER}-metrics.postgres.svc.cluster.local:9187/metrics"

def main():
    lines = []
    try:
        with urllib.request.urlopen(URL, timeout=5) as r:
            lines = [l.decode().strip() for l in r]
    except Exception as e:
        print(f"CRITICAL: {e}")
        sys.exit(2)

    max_conn, backends, deadlocks = 100, 0.0, 0.0

    for l in lines:
        if not l or l.startswith('#'):
            continue
        if 'cnpg_pg_settings_setting' in l and 'name="max_connections"' in l:
            max_conn = float(l.rsplit(' ', 1)[1])
            continue
        if 'cnpg_pg_stat_database_numbackends' in l and '{' in l:
            backends += float(l.rsplit(' ', 1)[1])
            continue
        if 'cnpg_pg_stat_database_deadlocks' in l and '{' in l:
            deadlocks += float(l.rsplit(' ', 1)[1])
            continue

    pct = (backends / max_conn) * 100
    errs = []

    if pct > SEUIL:
        errs.append(f"WARNING: Connexions {pct:.1f}% ({int(backends)}/{int(max_conn)})")
    if deadlocks > 0:
        errs.append(f"WARNING: Deadlocks detectes ({int(deadlocks)})")

    if errs:
        print("\n".join(errs))
        sys.exit(1)
    else:
        print(f"OK: Connexions {pct:.1f}% ({int(backends)}/{int(max_conn)}), Deadlocks {int(deadlocks)}")
        sys.exit(0)

main()