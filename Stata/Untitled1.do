reg ldurat afchnge highearn afhigh


      Source |       SS           df       MS      Number of obs   =     7,150
-------------+----------------------------------   F(3, 7146)      =     38.34
       Model |  193.919855         3  64.6399516   Prob > F        =    0.0000
    Residual |  12047.1908     7,146  1.68586493   R-squared       =    0.0158
-------------+----------------------------------   Adj R-squared   =    0.0154
       Total |  12241.1107     7,149  1.71228293   Root MSE        =    1.2984

------------------------------------------------------------------------------
      ldurat | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
     afchnge |   .0236351   .0397008     0.60   0.552    -.0541902    .1014603
    highearn |   .2151955   .0433612     4.96   0.000     .1301948    .3001963
      afhigh |   .1883498    .062794     3.00   0.003      .065255    .3114445
       _cons |   1.199336   .0271091    44.24   0.000     1.146194    1.252478
------------------------------------------------------------------------------

 reg ldurat afchnge highearn afhigh male married indust injtype

      Source |       SS           df       MS      Number of obs   =     6,824
-------------+----------------------------------   F(7, 6816)      =     21.03
       Model |  244.707976         7  34.9582823   Prob > F        =    0.0000
    Residual |  11329.2752     6,816  1.66215892   R-squared       =    0.0211
-------------+----------------------------------   Adj R-squared   =    0.0201
       Total |  11573.9832     6,823   1.6963188   Root MSE        =    1.2892

------------------------------------------------------------------------------
      ldurat | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
     afchnge |   .0219922     .04015     0.55   0.584    -.0567144    .1006989
    highearn |   .1797779   .0469284     3.83   0.000     .0877835    .2717723
      afhigh |   .2151064    .064014     3.36   0.001     .0896191    .3405938
        male |  -.0862377   .0402554    -2.14   0.032    -.1651509   -.0073244
     married |   .1183969   .0352929     3.35   0.001     .0492118    .1875821
      indust |   .0338827   .0178639     1.90   0.058    -.0011361    .0689016
     injtype |   .0353488     .01031     3.43   0.001     .0151379    .0555598
       _cons |   .9597444   .0735133    13.06   0.000     .8156355    1.103853
------------------------------------------------------------------------------

