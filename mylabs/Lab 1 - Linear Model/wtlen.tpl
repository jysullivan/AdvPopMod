//////////////////////////////////////////////
//  MAR 580: Advanced Population Modeling
//  Fall 2015
//  Gavin Fay
//  Jane Sullivan
//  Lab 1: weight length example
//////////////////////////////////////////////
DATA_SECTION
  init_int ndata;
  // 2-D matrix to hold data frame (rows= 1 to ndata, columns = 1-3)
  init_matrix data(1,ndata,1,3);
  // vectors to hold data
  vector subject(1,ndata);
  vector len(1,ndata);
  vector wt(1,ndata);
  // C code that extracts columns from data file in long format
  !! subject=column(data,1);
  !! len=column(data,2);
  !! wt=column(data,3);

//OTHER WAY MAYBE?

// LOCAL_CALCS

//  for (int i=1;i<=ndata;i++){subject(i) = data(i,1);}
//  for (int i=1;i<=ndata;i++){log_len(i) = log(data(i,2));}
//  for (int i=1;i<=ndata;i++){log_wt(i) = log(data(i,3));}

PARAMETER_SECTION

//  init_vector log_a;
//  init_vector b;

  // Initialize bounded  parameters (logging a, keep positive)
  init_bounded_number a(0.001,50);
  init_bounded_number b(-50,50);

// Vector for predicted values
  vector ypred(1,ndata);
  
  objective_function_value obj_fun;

PROCEDURE_SECTION

// weight-length formula
  ypred = log(a) + b*log(len);
  cout << ypred << endl;
  obj_fun = norm2(log(wt)-ypred);

REPORT_SECTION
  report << "a" << endl;
  report << a << endl;
  report << "b" << endl;
  report << b  << endl;  
  report << "ypred" << endl;
  report << mfexp(ypred) << endl;




