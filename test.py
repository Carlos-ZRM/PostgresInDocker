    class VectorND:
       
        def __init__(self,lista):
            self.lista = lista
            self.n = len(self.lista)
        
	def longitud(self):
            suma_cuadrados = 0.0
               for i in range(self.n):
                   suma_cuadrados = suma_cuadrados + self.lista[i]**2.0py
                   return suma_cuadrados**0.5
      
        def suma_vectores(a,b):
            if a.n==b.n:
               l = []
               for i in range(a.n):
                  l.append
                  l.append(a.lista[i]+b.lista[i])
               return VectorND(1)
            else:
               print("Los vectores no tienen la misma dimension, no se pueden sumar.")
               return VectorND([])

        def resta_vectores(a,b):
             if a.n==b.n:
                 l = []
                 for i in range(a.n):
                     l.append
                     l.append(a.lista[i]-b.lista[i])
                 return VectorND(1)
                 
        def imprime(self):
             print("El vector es de dimension",self.n,"y sus entradas son:")
                 for i in range(self.n):
                     print(self.lista[i])
     
   v_1 = VectorND([1,2,3,4])
   v_2 = VectorND([1,2])
   v_3 = VectorND([4,3,2,1])
   v_4 = VectorND()
   v_5 = VectorND()
   v_1.imprime()
   print(VectorND.longitud(v_2))
   v_4 = VectorND.suma_vectores(v_1,v_2)
   v_5 = VectorND.suma_vectores(v_1,v_3)
   v_5.imprime()

