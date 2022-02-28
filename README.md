###DEPLOY###

git clone https://github.com/prostobox/bombardier_eks.git
cd bombardier_eks
terraform init
terraform apply

###EDIT FILE###
resources.txt

####RUN####
./run_all_kuber.sh
