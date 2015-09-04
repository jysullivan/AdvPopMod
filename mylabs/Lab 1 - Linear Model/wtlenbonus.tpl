//////////////////////////////////////////////
//  MAR 580: Advanced Population Modeling
//  Fall 2015
//  Gavin Fay
//  Jane Sullivan
//  Lab 1: weight length example bonus
//////////////////////////////////////////////
DATA_SECTION
  init_int ndata;
  // 2-D matrix to hold data frame (rows= 1 to ndata, columns = 1-3)
  init_matrix data(1,ndata,1,3);
  // vectors to hold data
  // use ivector for subject (factor)
  ivector subject(1,ndata);
  !! subject=(ivector)column(data,1);   // C code that extracts columns from data file in long format
  vector len(1,ndata);
  !! len=column(data,2);
  vector wt(1,ndata);
  !! wt=column(data,3);


PARAMETER_SECTION

  // Initialize bounded  parameters (logging a, keep positive)
  init_bounded_vector a(1,10,0.001,50);
  init_bounded_number b(-50,50);

// Vector for predicted values
  vector ypred(1,ndata);
  
  objective_function_value obj_fun;

PROCEDURE_SECTION

// weight-length formula

   for(int i=1; i<=ndata; ++i){
           ypred = log(a(subject(i))) + b*log(len);
           obj_fun+= norm2(log(wt(subject(i)))-ypred);
  }

//  cout << ypred << endl;
REPORT_SECTION
  report << "a" << endl;
  report << a << endl;
  report << "b" << endl;
  report << b  << endl;  
  report << "ypred" << endl;
  report << mfexp(ypred) << endl;




