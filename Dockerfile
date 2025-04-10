# 使用官方 PHP 镜像作为基础
FROM php:8.1-fpm

# 安装必要的扩展
RUN docker-php-ext-install pdo_mysql

# 安装 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 设置工作目录
WORKDIR /var/www/html

# 复制项目文件到容器中
COPY . .

# 安装 PHP 依赖
RUN composer install --no-dev --optimize-autoloader

# 暴露端口（可选）
EXPOSE 9000

# 启动 PHP-FPM
CMD ["php-fpm"]