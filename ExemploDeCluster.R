
if( ! require("snow")) install.packages("snow")
library(snow)

# Objeto para teste
dados <- 1000 : 1
# fun��o para teste
funcao <- function(x) {
  mean(x)
}


# Cluster com o n�mero de processos equivalentes ao n�mero de n�cleos de processamento dispon�veis.
CL <- makeCluster(as.numeric(Sys.getenv("NUMBER_OF_PROCESSORS")), type = "SOCK")

# Exportando dados para dentro do cluster: 
  # clusterExport(CL, "NomeDoObjeto")
  clusterExport(CL, c("dados", "funcao"))
  # O cluster � como se fosse uma outra sess�o do R,
  # ent�o no cluster s� existe o que for carregado dentro dele.

# Utilizando o cluster:
  # ClusterApply � similar a fam�lia de fun��es apply
  # clusterApply(CL, vetor, fun��o)
  
  # Criando vetor
  x <- (1 : 1000) ^ 2

  y <- clusterApply(CL, x, function(i) {
    
    y <- dados + i
    y <- funcao(y)
    
    y <- c(Elemento = i, outputfuncao = y)
    
  })
  
  # perceba que o output � uma lista
  y <- matrix(unlist(y), ncol = 2, byrow = T)
  
  
  