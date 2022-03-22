needsPackage "VirtualResolutions"

-- Define Hilbert matrix (nxn) of an ideal
HM = (I,n) -> (
    matrix(apply(n,i-> apply(n,j-> hilbertFunction({i,j},I))))
    )

-- Define difference of a matrix
Diff = M -> (
    m := numgens target M;
    n := numgens source M;
    matrix(apply(m,i-> if i==0 then apply(n,j-> if j==0 then M_(0,0) else M_(i,j)-M_(i,j-1)) else apply(n,j-> if j==0 then M_(i,j)-M_(i-1,j) else M_(i,j)-M_(i,j-1)-M_(i-1,j)+M_(i-1,j-1))))
    )

--Define first difference function of the (nxn) Hilbert matrix of an ideal
DHM = (I,n) -> (Diff(HM(I,n)))

--Define second difference function of the (nxn)  Hilbert matrix of an ideal
D2HM = (I,n) -> (Diff(DHM(I,n)))

--Function to create an ideal I_n of n random (hopefully generic) points in P^1xP^1
genideal = n -> (
    apply(n,i-> (P_i = ideal(random({1,0},S),random({0,1},S))));
    I_n = intersect(apply(n,i->P_i))
    )

--Function to create the Hilbert matrix of a set of n generic points in P^1xP^1
genHM = n -> (
    matrix(apply(n+2,i->(apply(n+2,j-> min((i+1)*(j+1),n)))))
    )


-- testvirtual tests whether a map of free resolutions F --> G induces a map on virtualOfPairs (F,a) --> (G,b)
-- it returns true if it does and false if there is no induced map
testvirtual = (G,b,F,a) -> try (extend(virtualOfPair(G,{b+{1,1}}),virtualOfPair(F,{a+{1,1}}),inducedMap(G_0,F_0)); true) else false


-- virtualposet is a function that takes two ideals J containing I and outputs a list showing which minimal elements of
-- regularity give induced maps between the virtualOfPair complexes associated to those elements
virtualposet = (J,I) -> (
    r1 = multigradedRegularity(S,I);
    r2 = multigradedRegularity(S,J);
    L = select(r1**r2, (a,b) -> testvirtual(res J,b,res I,a));
    apply(L,(a,b)-> (a => b))
    )

---- nvirtualposet is a function that takes two ideals J containing I and outputs which maps are missing 
-- from the list provided by virtualposet. 
-- That is, it outputs the pairs that could have maps between them for degree reasons, but dont.
nvirtualposet = (J,I) -> (
    r1 = multigradedRegularity(S,I);
    r2 = multigradedRegularity(S,J);
    L = select(r1**r2, (a,b) -> not testvirtual(res J,b,res I,a) and not any(a-b,i -> i<0));
    apply(L,(a,b)-> (a => b))
    )
