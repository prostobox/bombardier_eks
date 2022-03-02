###DEPLOY TO AWS###

git clone https://github.com/prostobox/bombardier_eks.git

cd bombardier_eks

terraform init

terraform apply

aws eks update-kubeconfig --region eu-central-1 --name bombardier

###EDIT FILE###

resources.txt

####RUN####

./run_all_kuber.sh

###DELETE####

./delete_all_kuber.sh
