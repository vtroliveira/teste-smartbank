# Divisão das pastas
<p> arq_container: contém o desenho de solução proposta para transformar projetos java maven em containers </p>
<p> arq_log_centralizado: contém o desenho de solução proposta para problema do centralizador de logs </p>
<p> packer: contém o arquivo de script para funcionamento do packer </p>
<p> packer: contém os scripts para funcionamento do terraform </p>
<p> deploy.sh: script para chamada de toda a implementação de infraestrutura aws </p>

## Abaixo, descritivo sobre como executar a implantação da infraestrutura do teste

# Objetivo
Criar os recursos requeridos utilizando a infraestrutura aws na região 'us-east-1' e fazer o deploy de uma aplicação tomcat embaixo de um elastic load balancer

# Abordagem
Primeiramente será criada uma AMI imutável contendo a aplicação tomcat e depois toda a infraestrutura na aws. A imagem criada será usada como base na configuração da aplicação web via terraform

# Motivação
Packer = Este tipo de abordagem foi utilizada para criar imagens imutáveis de instâncias EC2. Com imagens imutáveis ganhamos várias vantagens na administração de recursos, tais como isolamento de regras, melhor análise de falhas e rollback de versão fácil e confiável

Application Load Balancer = A própria aws recomenda que todos os Classic Load Balancers sejam migrados para as duas novas estruturas de ELB: Application e Network. Por se tratar de um tomcat, escolhi o Application Load Balancer.

# Pré Requisitos
Ambiente Linux ou Mac OS

Instalar o packer
https://www.packer.io/docs/install/index.html

Instalar o terraform
https://learn.hashicorp.com/terraform/getting-started/install

Instalar o jq
https://stedolan.github.io/jq/

# Execução
<p>1 - Editar o arquivo deploy.sh atualizando as variáveis AWS_ACCESS_KEY e AWS_SECRET_ACCESS_KEY com as credenciais de um usuário na aws que contenha permissões para criação dos recursos requeridos no teste (preferencialmente administrador)</p>
<p>2 - Executar o arquivo deploy.sh</p>
