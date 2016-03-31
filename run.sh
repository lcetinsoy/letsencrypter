DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ${BASH_SOURCE[0]}
echo $DIR

sudo env "PATH=$PATH" $DIR/letsencrypter-nginx.sh

