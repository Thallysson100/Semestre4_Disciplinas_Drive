##################################################
# Tabela de Distribuição de frequência nas classes TDF
###############################################################

# O conjunto de dados já deve ter sido importado do excel com o nome "Dataset"

dados<-c(3.8, 8.5, 3.7, 4.1, 2.9, 3.9, 4.0, 7.9, 7.4, 9.6, 10.6, 10.7, 
11.9, 13.0, 14.0, 8.2, 9.2, 11.6, 9.9, 12.6, 14.9, 4.7, 4.8, 4.9, 5.1, 5.5, 
5.6, 5.7, 5.9, 6.2, 6.3, 7.3, 6.3, 6.4, 6.8, 6.9
);dados  #armazenando as observações no objeto dados

n<-length(dados); n #número de observações
k<-sqrt(n)+0.5; k<-round(k,0) #número de classes
C<-(max(dados)-min(dados))/(k-1);C<-round(C,2) #Amplitude de classe duas casas decimais
limites<-round(min(dados)-C/2,2)+C*(0:k);#limites
TDF<-hist(dados,breaks=limites,plot=FALSE,right=FALSE)
tabela<-matrix(c(rep(6*k)),k,6)
for(i in 1:k)
{tabela[i,1]<-round(TDF$breaks[i],2);tabela[i,2]<-round(TDF$breaks[i+1],2)
tabela[i,3]<-round(TDF$mids[i],2);tabela[i,4]<-(TDF$counts[i])
tabela[i,5]<-round(((TDF$counts[i])/n),4);tabela[i,6]<-round((100*TDF$counts[i])/n,2)
}
colnames(tabela)<-c("LI","LS","Xi","Fi","Fr","Fp")
tabela

##################################################
# Construindo o HIstograma 
#####################################################################


n<-length(dados); n #número de observações
k<-sqrt(n)+0.5; k<-round(k,0) #número de classes
C<-(max(dados)-min(dados))/(k-1);C<-round(C,2) #Amplitude de classe duas casas decimais
limites<-round(min(dados)-C/2,2)+C*(0:k);#limites
TDF<-hist(dados,breaks=limites,plot=FALSE,right=FALSE)
hist(dados,xlab="tempo de convergência (segundos)", ylab="Frequência absoluta",
label=FALSE,col="gray",main="",right=FALSE, 
xlim=c(min(TDF$mids)-C,max(TDF$mids)+C),ylim=c(0,(max(TDF$counts)+1)),breaks=limites,axes=FALSE)
axis(1,at=limites,pos=c(0,0))
axis(2,at=c(seq(0:(max(TDF$counts)+1))-1))
##################################################
# Construindo o polígono no HIstograma 
#####################################################################
Xip<-c(TDF$mids[1]-C,TDF$mids,TDF$mids[length(TDF$mids)]+C)
frequencia<-c(0,TDF$counts,0)
Xip
lines(frequencia~Xip,type="l",col="blue",lwd=2)



