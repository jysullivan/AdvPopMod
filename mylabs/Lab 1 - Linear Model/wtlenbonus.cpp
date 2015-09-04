#include <admodel.h>
#include <contrib.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <wtlenbonus.htp>

model_data::model_data(int argc,char * argv[]) : ad_comm(argc,argv)
{
  ndata.allocate("ndata");
  data.allocate(1,ndata,1,3,"data");
  subject.allocate(1,ndata);
 subject=(ivector)column(data,1);   // C code that extracts columns from data file in long format
  len.allocate(1,ndata);
 len=column(data,2);
  wt.allocate(1,ndata);
 wt=column(data,3);
}

model_parameters::model_parameters(int sz,int argc,char * argv[]) : 
 model_data(argc,argv) , function_minimizer(sz)
{
  initializationfunction();
  a.allocate(1,10,0.001,50,"a");
  b.allocate(-50,50,"b");
  ypred.allocate(1,ndata,"ypred");
  #ifndef NO_AD_INITIALIZE
    ypred.initialize();
  #endif
  obj_fun.allocate("obj_fun");
  prior_function_value.allocate("prior_function_value");
  likelihood_function_value.allocate("likelihood_function_value");
}

void model_parameters::userfunction(void)
{
  obj_fun =0.0;
   for(int i=1; i<=ndata; ++i){
           ypred = log(a(subject(i))) + b*log(len);
           obj_fun+= norm2(log(wt(subject(i)))-ypred);
  }
}

void model_parameters::report(const dvector& gradients)
{
 adstring ad_tmp=initial_params::get_reportfile_name();
  ofstream report((char*)(adprogram_name + ad_tmp));
  if (!report)
  {
    cerr << "error trying to open report file"  << adprogram_name << ".rep";
    return;
  }
  report << "a" << endl;
  report << a << endl;
  report << "b" << endl;
  report << b  << endl;  
  report << "ypred" << endl;
  report << mfexp(ypred) << endl;
}

void model_parameters::preliminary_calculations(void){
#if defined(USE_ADPVM)

  admaster_slave_variable_interface(*this);

#endif
}

model_data::~model_data()
{}

model_parameters::~model_parameters()
{}

void model_parameters::final_calcs(void){}

void model_parameters::set_runtime(void){}

#ifdef _BORLANDC_
  extern unsigned _stklen=10000U;
#endif


#ifdef __ZTC__
  extern unsigned int _stack=10000U;
#endif

  long int arrmblsize=0;

int main(int argc,char * argv[])
{
    ad_set_new_handler();
  ad_exit=&ad_boundf;
    gradient_structure::set_NO_DERIVATIVES();
    gradient_structure::set_YES_SAVE_VARIABLES_VALUES();
    if (!arrmblsize) arrmblsize=15000000;
    model_parameters mp(arrmblsize,argc,argv);
    mp.iprint=10;
    mp.preliminary_calculations();
    mp.computations(argc,argv);
    return 0;
}

extern "C"  {
  void ad_boundf(int i)
  {
    /* so we can stop here */
    exit(i);
  }
}
