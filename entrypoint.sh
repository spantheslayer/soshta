#!/bin/bash

sleep 10

cd /home/bagisto/bagisto && php artisan optimize:clear && php artisan migrate:fresh --seed && php artisan storage:link && php artisan bagisto:publish --force && php artisan optimize:clear

apache2-foreground
