SubCast est un projet universitaire dont l'objectif était de créer une plate-forme grand public fournissant la transcription de contenu audio.
Outre les contenus téléversés par l'utilisateur, il est également possible de s'abonner à des podcasts d'émissions pour en recevoir les transcriptions dans la foulée de leur mise en disponibilité.  
L'application, développée à l'aide du puissant framework Ruby on Rails, avait pour objectif de répondre à un besoin des malentendants mais aussi de Monsieur tout le monde, puisqu'il peut être plus pratique de lire des transcriptions plutôt que d'écouter une émission, par exemple par manque de temps. Cela présente par ailleurs un autre intérêt dans le cadre du traitement automatique du langage (résumés automatiques, recherche...). La fonction de recherche fait d'ailleurs partie des fonctionnalités disponibles de l'application.  
Les objectifs de développement ont été pleinement atteint et un journal de développement est disponible ici.  
Cependant, le projet n'est plus déployé en production pour le moment, pour des raisons pratiques (disponibilité du serveur de transcription, besoin d'un hébergement "costaud"). Il est possible que le projet reprenne vie un jour et peut-être même dans d'autres mains, puisque son code source est libéré sous licence GNU GPL.  
Notre équipe a en tout cas quelques pistes d'améliorations qu'elle se réserve pour un futur plus ou moins proche.

Gems utilisés:

* rails
* bootstrap
* delayed_job
* feedvalidator
* whenever
* daemons
* sunspot_rails et sunspot_solr
* feedjira
* webvtt
  
Le projet utilise le moteur de recherche et d'indexation d'Apache, Solr, à travers son binding ruby sunspot ainsi qu'une recherche plus légère écrite en javascript mais basée sur solr: lunr.js.
