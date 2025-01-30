#!/usr/bin/env python2.7

import argparse
import numpy as np
from scipy.stats import chi2
import statsmodels.api as sm
from scipy.optimize import minimize as optim

def set_options():
    myparser=argparse.ArgumentParser(description='Estimate hapflk distribution and/or calculate hapFLK p-values')
    myparser.add_argument('infiles',metavar='file',type=str,help='An input file',nargs='+')
    myparser.add_argument('K',metavar='K',type=float,help='Number of clusters')
    myparser.add_argument('N',metavar='N',type=float,help='Number of populations')
    myparser.add_argument('--pars',nargs=2,metavar=('mu','beta'),type=float,help='regression parameters',default=None)
    myparser.add_argument('--optimize',help='Optimize chi-squared df',action="store_true",default=False)
    return myparser

def estimate_hapflk_qreg(sample,K,Npop,probs=np.linspace(0.05,0.95,num=19)):
    ## observed quantiles
    oq=np.percentile(sample,q=list(100*probs))
    ## theoretical quantiles
    mydf=(K-1)*(Npop-1)
    tq=chi2.ppf(probs,df=mydf)
    ## robust regression
    reg=sm.RLM(tq,np.vstack([np.ones(len(oq)),oq]).T)
    res=reg.fit()
    mu,beta=res.params
    return {'mu':mu,'beta':beta,'df':mydf}

def qfunc(ndf,oq,probs):
    tq=chi2.ppf(probs,df=ndf)
    reg=sm.RLM(tq,np.vstack([np.ones(len(oq)),oq]).T)
    res=reg.fit()
    return np.sum(np.power(res.resid,2))

def optimize_hapflk_qreg(sample,K,Npop,probs=np.linspace(0.05,0.95,num=19)):
    oq=np.percentile(sample,q=list(100*probs))
    res=optim(qfunc,K,args=(oq,probs))
    mydf=res.x[0]
    tq=chi2.ppf(probs,df=mydf)
    ## robust regression
    reg=sm.RLM(tq,np.vstack([np.ones(len(oq)),oq]).T)
    res=reg.fit()
    mu,beta=res.params
    return {'mu':mu,'beta':beta,'df':mydf}
    
def scale_hapflk_sample(sample,params):
    scaled_sample=params['mu']+params['beta']*sample
    if scaled_sample < 0:
        scaled_sample=0
    pvalue=chi2.sf(scaled_sample,df=params['df'])
    return scaled_sample,pvalue

                        
def main():
    parser=set_options()
    args=parser.parse_args()
    flog=open('scaling_hapflk.log','w')
    datasets=[]
    filenames=[]
    for fic in args.infiles:
        print fic
        dset=np.genfromtxt(fic,dtype=None,names=True)
        datasets.append(dset)
        filenames.append(fic)
    if args.pars==None:
        hflk_sample=np.concatenate([x['hapflk'] for x in datasets])
        if args.optimize:
            reg_par=optimize_hapflk_qreg(hflk_sample,args.K,args.N)
        else:
            reg_par=estimate_hapflk_qreg(hflk_sample,args.K,args.N)
        print reg_par
    else:
        reg_par={'mu':args.pars[0],'beta':args.pars[1],'df':(args.K-1)*(args.N-1)}

    print >>flog,"regression parameters"
    for k,v in reg_par.items():
        print >>flog,k,v

    for i,d in enumerate(datasets):
        with open(filenames[i]+'_sc','w') as fout:
            print >>fout,'rs','chr','pos','hapflk','hapflk_scaled','pvalue'
            for x in d:
                xs=scale_hapflk_sample(x['hapflk'],reg_par)
                print >>fout,x['rs'],x['chr'],x['pos'],x['hapflk'],xs[0],xs[1]
    
                                 
if __name__=='__main__':
    main()
