ENV_FILE=$1
BOLD_RED='\033[1;91m'
BOLD_GREEN='\033[1;92m'
DEF='\033[0m'

REQUIRED_VARS=(
	DB_HOST \
	DB_NAME \
	DB_USER \
	DOMAIN \
	WORDPRESS_DB_HOST \
	WORDPRESS_DB_NAME \
	WORDPRESS_DB_USER \
	WORDPRESS_TITLE \
	WORDPRESS_ADMIN_USER \
	WORDPRESS_ADMIN_EMAIL \
	WORDPRESS_USER \
	WORDPRESS_USER_EMAIL \
	DB_HOST \
	DB_NAME \
	DB_USER \
	DOMAIN \
)

if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' $ENV_FILE | xargs)
else
  echo -e "${BOLD_RED}Error: .env file not found!${DEF}"
  exit 1
fi

#check for required env vars
for var in ${REQUIRED_VARS[@]}; do
	if [ -z "${!var}" ]; then
		echo -e "${BOLD_RED}Error: Environment variable $var is not set.${DEF}"
		exit 1
	fi
done

echo -e "${BOLD_GREEN}All required environment variables are set.${DEF}"