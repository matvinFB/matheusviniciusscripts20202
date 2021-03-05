# OK
BEGIN{
	redes = 0;
  	nredes = "nulo";
	engenharia = 0;
	nrengenharia = "nulo";
	sistemas = 0;
	nsitemas = "nulo";
		
}
{
	if($2 == "Redes"){
		if($3 > redes){
			redes = $3;
			nredes = $1;
		}
	}
	else if ($2 == "Sistemas"){
		if($3 > sistemas){ 
			sistemas = $3;
			nsistemas = $1;
		}
	}
	else if ($2 == "Engenharia"){
		if($3 > engenharia){
			engenharia = $3;
			nengenharia = $1;
		}
	}
}
END{
	e= "Engenharia:";
	r= "Redes:";
	s="Sistemas:";
	printf("%-10s %10s, %10d \n%-10s %10s, %10d\n%-10s: %10s, %10d\n", e,nengenharia, engenharia, r, nredes, redes, s, nsistemas, sistemas);
	
	}

