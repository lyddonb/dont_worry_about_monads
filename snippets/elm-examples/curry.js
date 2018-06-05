-- Btw this can be done in Javascript, Python, etc
-- Javascript:
> var myCurriableFunction = function (x, y, z){
    return function (y, z){
      x + y + z;
    }
  }

> myCurriableFunction(2);

function (y, z){  
  x + y + z;
}
