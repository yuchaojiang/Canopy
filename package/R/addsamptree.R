addsamptree = function(tree, tree.new) {
    r=exp(tree.new$likelihood - tree$likelihood)
    randr=runif(1,0,1)
    if(r >= randr){
        returntree = tree.new
        return.id =1
    } else{
        returntree = tree
        return.id = 0
    }
    return(list(returntree,return.id))
} 
