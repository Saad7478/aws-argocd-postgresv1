1. Diagnostic & État de santé (Le quotidien)
# Avant de toucher à quoi que ce soit, vous devez valider l'état du cluster et de la réplication.

# L'état global du cluster (La commande maîtresse de l'opérateur)
# Affiche le rôle (Primary/Standby), le lag de réplication, le statut TLS, etc.

kubectl cnpg status pg-cluster -n postgres

# Voir les 3 pods PostgreSQL et leur état de préparation (READY 1/1)

kubectl get pods -n postgres -l cnpg.io/cluster=pg-cluster

# Voir les services Kubernetes et la répartition Read-Write / Read-Only

kubectl get svc -n postgres -l cnpg.io/cluster=pg-cluster

# Voir l'état de l'application dans ArgoCD

argocd app get postgres

# Ou via kubectl si vous n'avez pas configuré la CLI argocd localement :

kubectl get application postgres -n argocd -o wide


2. Maintenance & Opérations DBA (Day 2)
# En production, vous aurez besoin de basculer le trafic, 
# de redémarrer des instances ou de modifier la configuration sans coupure.

Switchover (Bascule programmée)
Utile pour la maintenance planifiée sur le nœud hébergeant le Primary (ex: mise à jour de l'OS de la VM AWS).

# Basculer proprement le rôle de Primary vers une autre instance (choisie automatiquement)

kubectl cnpg switchover pg-cluster -n postgres

# Ou forcer la bascule vers une instance cible spécifique (ex: pg-cluster-3)

kubectl cnpg switchover pg-cluster --target pg-cluster-3 -n postgres

3. Redémarrage (Rolling Restart)
Si vous modifiez un paramètre Postgres dans Git (ex: max_connections) qui nécessite un redémarrage, ArgoCD va appliquer le YAML, puis l'opérateur va orchestrer un redémarrage séquentiel.

# Forcer un redémarrage en rolling-update (un pod après l'autre pour maintenir la HA)

kubectl cnpg reload pg-cluster -n postgres

# Redémarrer une seule instance spécifique (si le processus est bloqué)

kubectl cnpg restart pg-cluster-2 -n postgres

4. Synchronisation GitOps manuelle

# Forcer ArgoCD à synchroniser l'application avec le dépôt Git (écrase les dérives manuelles)

argocd app sync postgres

# Voir la différence exacte entre ce qui tourne en prod et ce qui est sur GitHub

argocd app diff postgres

5. Analyse des Logs & Performance
Le SRE doit traquer la latence et les erreurs à la seconde près.

# Streamer les logs du Master en temps réel (Utile pour voir les requêtes lentes)

kubectl logs -f pg-cluster-1 -n postgres

# Filtrer les logs pour ne voir que les erreurs PostgreSQL (via l'agent de l'opérateur)

kubectl logs -n postgres -l cnpg.io/cluster=pg-cluster --tail=100 | grep -E "ERROR|FATAL"

# Se connecter directement au prompt psql du Master pour du troubleshooting d'urgence

kubectl cnpg psql pg-cluster -n postgres

# Examiner les variables d'environnement actives à l'intérieur d'un pod Postgres

kubectl exec -it pg-cluster-1 -n postgres -- env

6. Gestion des Sauvegardes & DR (Disaster Recovery)
L'opérateur CNPG intègre Barman Cloud de manière transparente. Voici comment piloter vos sauvegardes vers AWS S3.


# Déclencher une sauvegarde physique immédiate (on-demand) vers AWS S3
# (Nécessite que la section 'backup' soit configurée dans votre YAML)

kubectl cnpg backup pg-cluster -n postgres

# Lister toutes les sauvegardes disponibles stockées sur S3 pour ce cluster

kubectl get backups -n postgres

# Inspecter le statut d'une sauvegarde spécifique

kubectl describe backup <nom-du-backup> -n postgres

7. Urgences & Chaos Engineering (En cas de crise)
# Le pire est arrivé ou vous souhaitez tester la résilience (Jalon 5).

Simuler un crash (Failover brutal)

# Tuer violemment le pod Master pour valider l'élection automatique du nouveau leader

kubectl delete pod pg-cluster-1 -n postgres --force --grace-period=0

8. Réinitialiser un Replica corrompu
# Si un replica est désynchronisé à cause d'une corruption de données ou d'un disque plein.

# Détruire le volume et recréer complètement le replica à partir du Primary actuel

kubectl cnpg destroy pg-cluster 2 -n postgres

9. En cas de blocage d'ArgoCD (Boucle infinie de Sync)
# Si ArgoCD bloque sur une ressource et n'arrive pas à la mettre à jour :

# Suspendre l'auto-synchronisation d'ArgoCD pour reprendre la main manuellement

argocd app set postgres --automated-policy-disabled

# Forcer la suppression d'une ressource Kubernetes qui refuse de mourir (Terminating)

kubectl patch application postgres -n argocd -p '{"metadata":{"finalizers":null}}' --type=merge

10. En production, gardez toujours un terminal ouvert sur 

kubectl cnpg status pg-cluster -n postgres -w