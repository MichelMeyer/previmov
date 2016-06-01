
if( ! require("snow")) install.packages("snow")
library(snow)

# Objeto para teste
dados <- 1000 : 1
# função para teste
funcao <- function(x) {
  mean(x)
}


# Cluster com o número de processos equivalentes ao número de núcleos de processamento disponíveis.
CL <- makeCluster(as.numeric(Sys.getenv("NUMBER_OF_PROCESSORS")), type = "SOCK")

# Exportando dados para dentro do cluster: 
  # clusterExport(CL, "NomeDoObjeto")
  clusterExport(CL, c("dados", "funcao"))
  # O cluster é como se fosse uma outra sessão do R,
  # então no cluster só existe o que for carregado dentro dele.

# Utilizando o cluster:
  # ClusterApply é similar a família de funções apply
  # clusterApply(CL, vetor, função)
  
  # Criando vetor
  x <- (1 : 1000) ^ 2

  y <- clusterApply(CL, x, function(i) {
    
    y <- dados + i
    y <- funcao(y)
    
    y <- c(Elemento = i, outputfuncao = y)
    
  })
  
  # perceba que o output é uma lista
  y <- matrix(unlist(y), ncol = 2, byrow = T)
  
  
  