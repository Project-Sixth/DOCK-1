FROM alpine:latest
# There is other versions of linux. Ubuntu. Debian/Minideb. Yet, I chose Alpine - it is as minimalistic as 10 MB. And 10 MB, boy, is such sweet size... Retains all the Linux functionality, also!


# Most users usually place information about maintainter, vendor and other shit here.
# But you know? Fuck this shit. If you want - you can fap on your (or someotherpersons) ownership elsewhere.
# I have thing/program. This thing works. And I really dont care who and how did it.
# So, if you really want to add LABEL maintainter, then just consider it as "Whole Humanity" as author.


# ====== Step 1: Get latest version of everything. ====== Just update your package manager goddamit, so you dont need to do that again anymore in every single command afterwards!

RUN apk update && apk upgrade
# Some prefer to use apk --update add, and I dont blame them. But personally I prefer slow and steady pace. Takes just a little bit of time. Gets guaranteed result. Strips you out of unnessesary commands.


# ====== Step 2: Create basic directories. ====== We WILL need them eventually, so why not set them up beforehand?

RUN mkdir /app /conf /run/nginx
# /app : directory for, well, DokuWiki itself
# /conf : directory for every single config file we will make (we kind of want to edit them. or backup them, if nessesary.)
# /run/nginx : directory for Nginx PID file


# ====== Step 3: Proceed to install DokuWiki dependencies. ======
# ===== Step 3.1: HTTP Webserver. =====

RUN apk add \
          nginx
# Nginx is basic HTTP(S) server.
# Not as basic as lighttpd - takes more time to configure.
# Not as powerful as and modular as apache2.
# But Nginx is open-sourced and extremely effective. It handle up to 10000 persons. Or even more. Also it doesnt chew through CPU. Perfect choice for any WIKIPEDIA.


# ===== Step 3.2: PHP. =====

RUN apk add \
          php7
# Installing basic PHP.
# Without it, cant build websites or anything at all. So, just install it.


# ===== Step 3.3: PHP FastCGI Process Manager.  =====

RUN apk add \
          php7-fpm
# Now we need a bridge between Nginx and PHP, and that is FPM.
# FPM is actually a bridge for 99% of things that is not Apache, I suppose.


# ===== Step 3.4: PHP Modules =====

RUN apk add \
          php7-calendar \
          php7-ctype \
          php7-exif \
          php7-fileinfo \
          php7-ftp \
          php7-gettext \
          php7-iconv \
          php7-json \
          php7-opcache \
          php7-pdo \
          php7-phar \
          php7-posix \
          php7-shmop \
          php7-sockets \
          php7-sysvmsg \
          php7-sysvsem \
          php7-sysvshm \
          php7-tokenizer \
		  php7-xml
RUN apk add \
          php7-gd \
		  php7-mbstring \
          php7-openssl \
          php7-session \
# DokuWiki requires (depending on official wikipedia page - https://www.dokuwiki.org/install:ubuntu) : libapache2-mod-php and php-xml
# Also, as official resource states, php-mbstring.
# And, I found that it also requires php-session (always) + php-openssl (for downloading addons) + php-gd (for resizing images, although, looks like it works even without it)
# Most of information found through making ubuntu docker and apt.


# ===== Step 3.DEBUG: Other modules =====
RUN apk add nano mc
# RUN apk add tzdata


# ====== Step 4: Install DokuWiki itself. ======
# ===== Step 4.1: Download latest DokuWiki from official website. =====

ADD https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz /tmp/dokuwiki.tgz
# We actually only need stable version.
# It is __latest__. It is __STABLE__.
# What the hell you want? You already get best of every single world.
# __And__ you do not need to install stupid curl/wgets into alpine system at all - you already have ADD command from Docker.
# Forget about fucking wget when you dont need it, ok?
# Keep. It. Simple.


# ===== Step 4.2: Extract DokuWiki archive in place, then, remove temporary files. =====

RUN tar -xzf /tmp/dokuwiki.tgz --strip 1 -C /app && \
    rm -rf /tmp/*
# To extract we use built-in tar utility, with flags '(x)tract' 'g(z)ip' '(f)ile that is located at tmp' 'strip first folder' 'send (C)ontents to /app'
# Then we clear tmp directory. We don't need it anymore, since we already placed all files where they needed.


# ===== Step 5: Pre-configure software =====
# ===== Step 5.1: Copy configuration files to Docker =====

ADD r /
# Actually I really want to use heredocs, so you dont need anymore items. But sadly, it is impossible.


# ===== Step 5.2: Fix permissions to files =====
RUN chown -R nginx:nginx /app


EXPOSE 80