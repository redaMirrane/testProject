FROM php:8.2-fpm

# Étape 1: Mise à jour des paquets et installation des dépendances nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    git \
    unzip \
    build-essential \
    autoconf \
    bison \
    re2c \
    libxml2-dev \
    libxslt-dev \
    && apt-get clean

# Étape 2: Installation des extensions PHP nécessaires
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl opcache pdo pdo_mysql zip calendar

# Étape 3: Installation de Composer (gestionnaire de dépendances PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copier le code de l'application dans le conteneur
COPY . /var/www/html/

# Configuration du répertoire de travail
WORKDIR /var/www/html/

# Installation des dépendances PHP avec Composer
RUN composer install --no-dev --optimize-autoloader

# Exposer le port 9000 pour le serveur PHP-FPM
EXPOSE 9000

# Commande pour exécuter PHP-FPM
CMD ["php-fpm"]
