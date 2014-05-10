function gibbs = gsw_gibbs(ns,nt,np,SA,t,p)

% gsw_gibbs                                Gibbs energy and its derivatives
% =========================================================================
%
% USAGE:
%   gibbs = gsw_gibbs(ns,nt,np,SA,t,p)
%
% DESCRIPTION:
%  Calculates specific Gibbs energy and its derivatives up to order 2 for
%  seawater.  The Gibbs function for seawater is that of TEOS-10
%  (IOC et al., 2010), being the sum of IAPWS-08 for the saline part and
%  IAPWS-09 for the pure water part.  These IAPWS releases are the
%  officially blessed IAPWS descriptions of Feistel (2008) and the pure
%  water part of Feistel (2003).  Absolute Salinity, SA, in all of the GSW
%  routines is expressed on the Reference-Composition Salinity Scale of 
%  2008 (RCSS-08) of Millero et al. (2008). 
%
% INPUT:
%  ns  =  order of SA derivative                     [ integers 0, 1 or 2 ]
%  nt  =  order of t derivative                      [ integers 0, 1 or 2 ]
%  np  =  order of p derivative                      [ integers 0, 1 or 2 ]
%  SA  =  Absolute Salinity                                        [ g/kg ]
%  t   =  in-situ temperature (ITS-90)                            [ deg C ]
%  p   =  sea pressure                                             [ dbar ]
%         (ie. absolute pressure - 10.1325 dbar) 
%  SA, t and p need to have the same dimensions.
%
% OUTPUT:
%  gibbs  =  Specific Gibbs energy or its derivatives.
%
%            The Gibbs energy (when ns = nt = np = 0) has units of:
%                                                                  [ J/kg ]
%            The Absolute Salinity derivatives are output in units of:
%                                                   [ (J/kg) (g/kg)^(-ns) ]
%            The temperature derivatives are output in units of: 
%                                                      [ (J/kg) (K)^(-nt) ]
%            The pressure derivatives are output in units of:
%                                                     [ (J/kg) (Pa)^(-np) ]
%            The mixed derivatives are output in units of:
%                              [ (J/kg) (g/kg)^(-ns) (K)^(-nt) (Pa)^(-np) ]
%  Note. The derivatives are taken with respect to pressure in Pa, not
%    withstanding that the pressure input into this routine is in dbar.
%
% AUTHOR: 
%  David Jackett                                       [ help@teos-10.org ]
%
% MODIFIED:
%  Trevor McDougall and Paul Barker 
%
% VERSION NUMBER: 3.01 (29th March, 2011) 
%  This function is unchanged from version 2.0 (24th September, 2010).
%
% REFERENCES:
%  Feistel, R., 2003: A new extended Gibbs thermodynamic potential of 
%   seawater,  Progr. Oceanogr., 58, 43-114. 
%
%  Feistel, R., 2008: A Gibbs function for seawater thermodynamics 
%   for -6 to 80�C and salinity up to 120 g kg�1, Deep-Sea Res. I, 
%   55, 1639-1671.
%
%  IAPWS, 2008: Release on the IAPWS Formulation 2008 for the 
%   Thermodynamic Properties of Seawater. The International Association 
%   for the Properties of Water and Steam. Berlin, Germany, September 
%   2008, available from http://www.iapws.org.  This Release is referred
%   to as IAPWS-08. 
%
%  IAPWS, 2009: Supplementary Release on a Computationally Efficient 
%   Thermodynamic Formulation for Liquid Water for Oceanographic Use. 
%   The International Association for the Properties of Water and Steam. 
%   Doorwerth, The Netherlands, September 2009, available from 
%   http://www.iapws.org.  This Release is referred to as IAPWS-09. 
%
%  IOC, SCOR and IAPSO, 2010: The international thermodynamic equation of 
%   seawater - 2010: Calculation and use of thermodynamic properties.  
%   Intergovernmental Oceanographic Commission, Manuals and Guides No. 56,
%   UNESCO (English), 196 pp.  Available from http://www.TEOS-10.org
%    See section 2.6 and appendices A.6,  G and H of this TEOS-10 Manual. 
%
%  Millero, F. J., R. Feistel, D. G. Wright, and T. J. McDougall, 2008: 
%   The composition of Standard Seawater and the definition of the 
%   Reference-Composition Salinity Scale, Deep-Sea Res. I, 55, 50-72. 
%
%  The software is available from http://www.TEOS-10.org
%
%==========================================================================

% These few lines ensure that SA is non-negative.
[I_neg_SA] = find(SA < 0);
if ~isempty(I_neg_SA)
    SA(I_neg_SA) = 0;
end

sfac = 0.0248826675584615;                   % sfac = 1/(40*(35.16504/35)).

x2 = sfac.*SA;
x = sqrt(x2);
y = t.*0.025d0;
z = p.*1d-4; %Note.The input pressure (p) is sea pressure in units of dbar.

if ns==0 & nt==0 & np==0
    
    g03 = 101.342743139674 + z.*(100015.695367145 + ...
        z.*(-2544.5765420363 + z.*(284.517778446287 + ...
        z.*(-33.3146754253611 + (4.20263108803084 - 0.546428511471039.*z).*z)))) + ...
        y.*(5.90578347909402 + z.*(-270.983805184062 + ...
        z.*(776.153611613101 + z.*(-196.51255088122 + (28.9796526294175 - 2.13290083518327.*z).*z))) + ...
        y.*(-12357.785933039 + z.*(1455.0364540468 + ...
        z.*(-756.558385769359 + z.*(273.479662323528 + z.*(-55.5604063817218 + 4.34420671917197.*z)))) + ...
        y.*(736.741204151612 + z.*(-672.50778314507 + ...
        z.*(499.360390819152 + z.*(-239.545330654412 + (48.8012518593872 - 1.66307106208905.*z).*z))) + ...
        y.*(-148.185936433658 + z.*(397.968445406972 + ...
        z.*(-301.815380621876 + (152.196371733841 - 26.3748377232802.*z).*z)) + ...
        y.*(58.0259125842571 + z.*(-194.618310617595 + ...
        z.*(120.520654902025 + z.*(-55.2723052340152 + 6.48190668077221.*z))) + ...
        y.*(-18.9843846514172 + y.*(3.05081646487967 - 9.63108119393062.*z) + ...
        z.*(63.5113936641785 + z.*(-22.2897317140459 + 8.17060541818112.*z))))))));
    
    g08 = x2.*(1416.27648484197 + z.*(-3310.49154044839 + ...
        z.*(384.794152978599 + z.*(-96.5324320107458 + (15.8408172766824 - 2.62480156590992.*z).*z))) + ...
        x.*(-2432.14662381794 + x.*(2025.80115603697 + ...
        y.*(543.835333000098 + y.*(-68.5572509204491 + ...
        y.*(49.3667694856254 + y.*(-17.1397577419788 + 2.49697009569508.*y))) - 22.6683558512829.*z) + ...
        x.*(-1091.66841042967 - 196.028306689776.*y + ...
        x.*(374.60123787784 - 48.5891069025409.*x + 36.7571622995805.*y) + 36.0284195611086.*z) + ...
        z.*(-54.7919133532887 + (-4.08193978912261 - 30.1755111971161.*z).*z)) + ...
        z.*(199.459603073901 + z.*(-52.2940909281335 + (68.0444942726459 - 3.41251932441282.*z).*z)) + ...
        y.*(-493.407510141682 + z.*(-175.292041186547 + (83.1923927801819 - 29.483064349429.*z).*z) + ...
        y.*(-43.0664675978042 + z.*(383.058066002476 + z.*(-54.1917262517112 + 25.6398487389914.*z)) + ...
        y.*(-10.0227370861875 - 460.319931801257.*z + y.*(0.875600661808945 + 234.565187611355.*z))))) + ...
        y.*(168.072408311545 + z.*(729.116529735046 + ...
        z.*(-343.956902961561 + z.*(124.687671116248 + z.*(-31.656964386073 + 7.04658803315449.*z)))) + ...
        y.*(880.031352997204 + y.*(-225.267649263401 + ...
        y.*(91.4260447751259 + y.*(-21.6603240875311 + 2.13016970847183.*y) + ...
        z.*(-297.728741987187 + (74.726141138756 - 36.4872919001588.*z).*z)) + ...
        z.*(694.244814133268 + z.*(-204.889641964903 + (113.561697840594 - 11.1282734326413.*z).*z))) + ...
        z.*(-860.764303783977 + z.*(337.409530269367 + ...
        z.*(-178.314556207638 + (44.2040358308 - 7.92001547211682.*z).*z))))));
    
    inds = find(x>0);
    if ~isempty(inds)
        g08(inds) = g08(inds) + x2(inds).*(5812.81456626732 + 851.226734946706.*y(inds)).*log(x(inds));
    end
    
    gibbs = g03 + g08;
    
elseif ns==1 & nt==0 & np==0
    
    g08 = 8645.36753595126 + z.*(-6620.98308089678 + ...
        z.*(769.588305957198 + z.*(-193.0648640214916 + (31.6816345533648 - 5.24960313181984.*z).*z))) + ...
        x.*(-7296.43987145382 + x.*(8103.20462414788 + ...
        y.*(2175.341332000392 + y.*(-274.2290036817964 + ...
        y.*(197.4670779425016 + y.*(-68.5590309679152 + 9.98788038278032.*y))) - 90.6734234051316.*z) + ...
        x.*(-5458.34205214835 - 980.14153344888.*y + ...
        x.*(2247.60742726704 - 340.1237483177863.*x + 220.542973797483.*y) + 180.142097805543.*z) + ...
        z.*(-219.1676534131548 + (-16.32775915649044 - 120.7020447884644.*z).*z)) + ...
        z.*(598.378809221703 + z.*(-156.8822727844005 + (204.1334828179377 - 10.23755797323846.*z).*z)) + ...
        y.*(-1480.222530425046 + z.*(-525.876123559641 + (249.57717834054571 - 88.449193048287.*z).*z) + ...
        y.*(-129.1994027934126 + z.*(1149.174198007428 + z.*(-162.5751787551336 + 76.9195462169742.*z)) + ...
        y.*(-30.0682112585625 - 1380.9597954037708.*z + y.*(2.626801985426835 + 703.695562834065.*z))))) + ...
        y.*(1187.3715515697959 + z.*(1458.233059470092 + ...
        z.*(-687.913805923122 + z.*(249.375342232496 + z.*(-63.313928772146 + 14.09317606630898.*z)))) + ...
        y.*(1760.062705994408 + y.*(-450.535298526802 + ...
        y.*(182.8520895502518 + y.*(-43.3206481750622 + 4.26033941694366.*y) + ...
        z.*(-595.457483974374 + (149.452282277512 - 72.9745838003176.*z).*z)) + ...
        z.*(1388.489628266536 + z.*(-409.779283929806 + (227.123395681188 - 22.2565468652826.*z).*z))) + ...
        z.*(-1721.528607567954 + z.*(674.819060538734 + ...
        z.*(-356.629112415276 + (88.4080716616 - 15.84003094423364.*z).*z)))));
    
    inds = find(x>0);
    if ~isempty(inds)
        g08(inds) = g08(inds) + (11625.62913253464 + 1702.453469893412.*y(inds)).*log(x(inds));
    end
    
    inds = find(x==0);
    if ~isempty(inds)
        g08(inds) = nan;
    end
    
    gibbs = 0.5.*sfac.*g08;   
    
elseif ns==0 & nt==1 & np==0
    
    g03 = 5.90578347909402 + z.*(-270.983805184062 + ...
        z.*(776.153611613101 + z.*(-196.51255088122 + (28.9796526294175 - 2.13290083518327.*z).*z))) + ...
        y.*(-24715.571866078 + z.*(2910.0729080936 + ...
        z.*(-1513.116771538718 + z.*(546.959324647056 + z.*(-111.1208127634436 + 8.68841343834394.*z)))) + ...
        y.*(2210.2236124548363 + z.*(-2017.52334943521 + ...
        z.*(1498.081172457456 + z.*(-718.6359919632359 + (146.4037555781616 - 4.9892131862671505.*z).*z))) + ...
        y.*(-592.743745734632 + z.*(1591.873781627888 + ...
        z.*(-1207.261522487504 + (608.785486935364 - 105.4993508931208.*z).*z)) + ...
        y.*(290.12956292128547 + z.*(-973.091553087975 + ...
        z.*(602.603274510125 + z.*(-276.361526170076 + 32.40953340386105.*z))) + ...
        y.*(-113.90630790850321 + y.*(21.35571525415769 - 67.41756835751434.*z) + ...
        z.*(381.06836198507096 + z.*(-133.7383902842754 + 49.023632509086724.*z)))))));
    
    g08 = x2.*(168.072408311545 + z.*(729.116529735046 + ...
        z.*(-343.956902961561 + z.*(124.687671116248 + z.*(-31.656964386073 + 7.04658803315449.*z)))) + ...
        x.*(-493.407510141682 + x.*(543.835333000098 + x.*(-196.028306689776 + 36.7571622995805.*x) + ...
        y.*(-137.1145018408982 + y.*(148.10030845687618 + y.*(-68.5590309679152 + 12.4848504784754.*y))) - ...
        22.6683558512829.*z) + z.*(-175.292041186547 + (83.1923927801819 - 29.483064349429.*z).*z) + ...
        y.*(-86.1329351956084 + z.*(766.116132004952 + z.*(-108.3834525034224 + 51.2796974779828.*z)) + ...
        y.*(-30.0682112585625 - 1380.9597954037708.*z + y.*(3.50240264723578 + 938.26075044542.*z)))) + ...
        y.*(1760.062705994408 + y.*(-675.802947790203 + ...
        y.*(365.7041791005036 + y.*(-108.30162043765552 + 12.78101825083098.*y) + ...
        z.*(-1190.914967948748 + (298.904564555024 - 145.9491676006352.*z).*z)) + ...
        z.*(2082.7344423998043 + z.*(-614.668925894709 + (340.685093521782 - 33.3848202979239.*z).*z))) + ...
        z.*(-1721.528607567954 + z.*(674.819060538734 + ...
        z.*(-356.629112415276 + (88.4080716616 - 15.84003094423364.*z).*z)))));
    
    inds = find(x>0);
    if ~isempty(inds)
        g08(inds) = g08(inds) + 851.226734946706.*x2(inds).*log(x(inds));
    end
    
    gibbs = (g03 + g08).*0.025d0;
    
elseif ns==0 & nt==0 & np==1
    
    g03 = 100015.695367145 + z.*(-5089.1530840726 + ...
        z.*(853.5533353388611 + z.*(-133.2587017014444 + (21.0131554401542 - 3.278571068826234.*z).*z))) + ...
        y.*(-270.983805184062 + z.*(1552.307223226202 + ...
        z.*(-589.53765264366 + (115.91861051767 - 10.664504175916349.*z).*z)) + ...
        y.*(1455.0364540468 + z.*(-1513.116771538718 + ...
        z.*(820.438986970584 + z.*(-222.2416255268872 + 21.72103359585985.*z))) + ...
        y.*(-672.50778314507 + z.*(998.720781638304 + ...
        z.*(-718.6359919632359 + (195.2050074375488 - 8.31535531044525.*z).*z)) + ...
        y.*(397.968445406972 + z.*(-603.630761243752 + (456.589115201523 - 105.4993508931208.*z).*z) + ...
        y.*(-194.618310617595 + y.*(63.5113936641785 - 9.63108119393062.*y + ...
        z.*(-44.5794634280918 + 24.511816254543362.*z)) + ...
        z.*(241.04130980405 + z.*(-165.8169157020456 + 25.92762672308884.*z)))))));
    
    
    g08 = x2.*(-3310.49154044839 + z.*(769.588305957198 + ...
        z.*(-289.5972960322374 + (63.3632691067296 - 13.1240078295496.*z).*z)) + ...
        x.*(199.459603073901 + x.*(-54.7919133532887 + 36.0284195611086.*x - 22.6683558512829.*y + ...
        (-8.16387957824522 - 90.52653359134831.*z).*z) + ...
        z.*(-104.588181856267 + (204.1334828179377 - 13.65007729765128.*z).*z) + ...
        y.*(-175.292041186547 + (166.3847855603638 - 88.449193048287.*z).*z + ...
        y.*(383.058066002476 + y.*(-460.319931801257 + 234.565187611355.*y) + ...
        z.*(-108.3834525034224 + 76.9195462169742.*z)))) + ...
        y.*(729.116529735046 + z.*(-687.913805923122 + ...
        z.*(374.063013348744 + z.*(-126.627857544292 + 35.23294016577245.*z))) + ...
        y.*(-860.764303783977 + y.*(694.244814133268 + ...
        y.*(-297.728741987187 + (149.452282277512 - 109.46187570047641.*z).*z) + ...
        z.*(-409.779283929806 + (340.685093521782 - 44.5130937305652.*z).*z)) + ...
        z.*(674.819060538734 + z.*(-534.943668622914 + (176.8161433232 - 39.600077360584095.*z).*z)))));
    
    gibbs = (g03 + g08).*1e-8;
    % Note. This pressure derivative of the gibbs function is in units of (J/kg) (Pa^-1) = m^3/kg
        
elseif ns==1 & nt==1 & np==0
    
    g08 = 1187.3715515697959 + z.*(1458.233059470092 + ...
        z.*(-687.913805923122 + z.*(249.375342232496 + z.*(-63.313928772146 + 14.09317606630898.*z)))) + ...
        x.*(-1480.222530425046 + x.*(2175.341332000392 + x.*(-980.14153344888 + 220.542973797483.*x) + ...
        y.*(-548.4580073635929 + y.*(592.4012338275047 + y.*(-274.2361238716608 + 49.9394019139016.*y))) - ...
        90.6734234051316.*z) + z.*(-525.876123559641 + (249.57717834054571 - 88.449193048287.*z).*z) + ...
        y.*(-258.3988055868252 + z.*(2298.348396014856 + z.*(-325.1503575102672 + 153.8390924339484.*z)) + ...
        y.*(-90.2046337756875 - 4142.8793862113125.*z + y.*(10.50720794170734 + 2814.78225133626.*z)))) + ...
        y.*(3520.125411988816 + y.*(-1351.605895580406 + ...
        y.*(731.4083582010072 + y.*(-216.60324087531103 + 25.56203650166196.*y) + ...
        z.*(-2381.829935897496 + (597.809129110048 - 291.8983352012704.*z).*z)) + ...
        z.*(4165.4688847996085 + z.*(-1229.337851789418 + (681.370187043564 - 66.7696405958478.*z).*z))) + ...
        z.*(-3443.057215135908 + z.*(1349.638121077468 + ...
        z.*(-713.258224830552 + (176.8161433232 - 31.68006188846728.*z).*z))));
    
    inds = find(x>0);
    if ~isempty(inds)
        g08(inds) = g08(inds) + 1702.453469893412.*log(x(inds));
    end
    
    inds = find(SA==0);
    if ~isempty(inds)
        g08(inds) = nan;
    end
    
    gibbs = 0.5.*sfac.*0.025d0.*g08;
  
elseif ns==1 & nt==0 & np==1
    
    g08 =     -6620.98308089678 + z.*(1539.176611914396 + ...
        z.*(-579.1945920644748 + (126.7265382134592 - 26.2480156590992.*z).*z)) + ...
        x.*(598.378809221703 + x.*(-219.1676534131548 + 180.142097805543.*x - 90.6734234051316.*y + ...
        (-32.65551831298088 - 362.10613436539325.*z).*z) + ...
        z.*(-313.764545568801 + (612.4004484538132 - 40.95023189295384.*z).*z) + ...
        y.*(-525.876123559641 + (499.15435668109143 - 265.347579144861.*z).*z + ...
        y.*(1149.174198007428 + y.*(-1380.9597954037708 + 703.695562834065.*y) + ...
        z.*(-325.1503575102672 + 230.7586386509226.*z)))) + ...
        y.*(1458.233059470092 + z.*(-1375.827611846244 + ...
        z.*(748.126026697488 + z.*(-253.255715088584 + 70.4658803315449.*z))) + ...
        y.*(-1721.528607567954 + y.*(1388.489628266536 + ...
        y.*(-595.457483974374 + (298.904564555024 - 218.92375140095282.*z).*z) + ...
        z.*(-819.558567859612 + (681.370187043564 - 89.0261874611304.*z).*z)) + ...
        z.*(1349.638121077468 + z.*(-1069.887337245828 + (353.6322866464 - 79.20015472116819.*z).*z))));
    
    gibbs = g08.*sfac.*0.5d-8;
    % Note. This derivative of the Gibbs function is in units of (m^3/kg)/(g/kg) = m^3/g,
    % that is, it is the derivative of specific volume with respect to Absolute
    % Salinity measured in g/kg.
    
elseif ns==0 & nt==1 & np==1
    
    g03 = -270.983805184062 + z.*(1552.307223226202 + z.*(-589.53765264366 + ...
        (115.91861051767 - 10.664504175916349.*z).*z)) + ...
        y.*(2910.0729080936 + z.*(-3026.233543077436 + ...
        z.*(1640.877973941168 + z.*(-444.4832510537744 + 43.4420671917197.*z))) + ...
        y.*(-2017.52334943521 + z.*(2996.162344914912 + ...
        z.*(-2155.907975889708 + (585.6150223126464 - 24.946065931335752.*z).*z)) + ...
        y.*(1591.873781627888 + z.*(-2414.523044975008 + (1826.356460806092 - 421.9974035724832.*z).*z) + ...
        y.*(-973.091553087975 + z.*(1205.20654902025 + z.*(-829.084578510228 + 129.6381336154442.*z)) + ...
        y.*(381.06836198507096 - 67.41756835751434.*y + z.*(-267.4767805685508 + 147.07089752726017.*z))))));
    
    g08 = x2.*(729.116529735046 + z.*(-687.913805923122 + ...
        z.*(374.063013348744 + z.*(-126.627857544292 + 35.23294016577245.*z))) + ...
        x.*(-175.292041186547 - 22.6683558512829.*x + (166.3847855603638 - 88.449193048287.*z).*z + ...
        y.*(766.116132004952 + y.*(-1380.9597954037708 + 938.26075044542.*y) + ...
        z.*(-216.7669050068448 + 153.8390924339484.*z))) + ...
        y.*(-1721.528607567954 + y.*(2082.7344423998043 + ...
        y.*(-1190.914967948748 + (597.809129110048 - 437.84750280190565.*z).*z) + ...
        z.*(-1229.337851789418 + (1022.055280565346 - 133.5392811916956.*z).*z)) + ...
        z.*(1349.638121077468 + z.*(-1069.887337245828 + (353.6322866464 - 79.20015472116819.*z).*z))));
    
    gibbs = (g03 + g08).*2.5e-10;
    % Note. This derivative of the Gibbs function is in units of (m^3/(K kg)),
    % that is, the pressure of the derivative in Pa.
    
elseif ns==2 & nt==0 & np==0
    
    g08 = 2.0.*(8103.20462414788 + ...
        y.*(2175.341332000392 + y.*(-274.2290036817964 + ...
        y.*(197.4670779425016 + y.*(-68.5590309679152 + 9.98788038278032.*y))) - 90.6734234051316.*z) + ...
        1.5.*x.*(-5458.34205214835 - 980.14153344888.*y + ...
        (4.0./3.0).*x.*(2247.60742726704 - 340.1237483177863.*1.25.*x + 220.542973797483.*y) + ...
        180.142097805543.*z) + ...
        z.*(-219.1676534131548 + (-16.32775915649044 - 120.7020447884644.*z).*z));
    
    inds = find(x>0);
    if ~isempty(inds)
        g08(inds) = g08(inds) + (-7296.43987145382 + z(inds).*(598.378809221703 + ...
            z(inds).*(-156.8822727844005 + (204.1334828179377 - 10.23755797323846.*z(inds)).*z(inds))) + ...
            y(inds).*(-1480.222530425046 + z(inds).*(-525.876123559641 + ...
            (249.57717834054571 - 88.449193048287.*z(inds)).*z(inds)) + ...
            y(inds).*(-129.1994027934126 + z(inds).*(1149.174198007428 + ...
            z(inds).*(-162.5751787551336 + 76.9195462169742.*z(inds))) + ...
            y(inds).*(-30.0682112585625 - 1380.9597954037708.*z(inds) + ...
            y(inds).*(2.626801985426835 + 703.695562834065.*z(inds))))))./x(inds) + ...
            (11625.62913253464 + 1702.453469893412.*y(inds))./x2(inds);
    end
    
    inds = find(x==0);
    if ~isempty(inds)
        g08(inds) = nan;
    end
    
    gibbs = 0.25.*sfac.*sfac.*g08;

elseif ns==0 & nt==2 & np==0
    
    g03 = -24715.571866078 + z.*(2910.0729080936 + z.* ...
        (-1513.116771538718 + z.*(546.959324647056 + z.*(-111.1208127634436 + 8.68841343834394.*z)))) + ...
        y.*(4420.4472249096725 + z.*(-4035.04669887042 + ...
        z.*(2996.162344914912 + z.*(-1437.2719839264719 + (292.8075111563232 - 9.978426372534301.*z).*z))) + ...
        y.*(-1778.231237203896 + z.*(4775.621344883664 + ...
        z.*(-3621.784567462512 + (1826.356460806092 - 316.49805267936244.*z).*z)) + ...
        y.*(1160.5182516851419 + z.*(-3892.3662123519 + ...
        z.*(2410.4130980405 + z.*(-1105.446104680304 + 129.6381336154442.*z))) + ...
        y.*(-569.531539542516 + y.*(128.13429152494615 - 404.50541014508605.*z) + ...
        z.*(1905.341809925355 + z.*(-668.691951421377 + 245.11816254543362.*z))))));
    
    g08 = x2.*(1760.062705994408 + x.*(-86.1329351956084 + ...
        x.*(-137.1145018408982 + y.*(296.20061691375236 + y.*(-205.67709290374563 + 49.9394019139016.*y))) + ...
        z.*(766.116132004952 + z.*(-108.3834525034224 + 51.2796974779828.*z)) + ...
        y.*(-60.136422517125 - 2761.9195908075417.*z + y.*(10.50720794170734 + 2814.78225133626.*z))) + ...
        y.*(-1351.605895580406 + y.*(1097.1125373015109 + y.*(-433.20648175062206 + 63.905091254154904.*y) + ...
        z.*(-3572.7449038462437 + (896.713693665072 - 437.84750280190565.*z).*z)) + ...
        z.*(4165.4688847996085 + z.*(-1229.337851789418 + (681.370187043564 - 66.7696405958478.*z).*z))) + ...
        z.*(-1721.528607567954 + z.*(674.819060538734 + ...
        z.*(-356.629112415276 + (88.4080716616 - 15.84003094423364.*z).*z))));
    
    gibbs = (g03 + g08).*0.000625;
      
elseif ns==0 & nt==0 & np==2
    
    g03 = -5089.1530840726 + z.*(1707.1066706777221 + ...
        z.*(-399.7761051043332 + (84.0526217606168 - 16.39285534413117.*z).*z)) + ...
        y.*(1552.307223226202 + z.*(-1179.07530528732 + (347.75583155301 - 42.658016703665396.*z).*z) + ...
        y.*(-1513.116771538718 + z.*(1640.877973941168 + z.*(-666.7248765806615 + 86.8841343834394.*z)) + ...
        y.*(998.720781638304 + z.*(-1437.2719839264719 + (585.6150223126464 - 33.261421241781.*z).*z) + ...
        y.*(-603.630761243752 + (913.178230403046 - 316.49805267936244.*z).*z + ...
        y.*(241.04130980405 + y.*(-44.5794634280918 + 49.023632509086724.*z) + ...
        z.*(-331.6338314040912 + 77.78288016926652.*z))))));
    
    g08 = x2.*(769.588305957198 + z.*(-579.1945920644748 + (190.08980732018878 - 52.4960313181984.*z).*z) + ...
        x.*(-104.588181856267 + x.*(-8.16387957824522 - 181.05306718269662.*z) + ...
        (408.2669656358754 - 40.95023189295384.*z).*z + ...
        y.*(166.3847855603638 - 176.898386096574.*z + y.*(-108.3834525034224 + 153.8390924339484.*z))) + ...
        y.*(-687.913805923122 + z.*(748.126026697488 + z.*(-379.883572632876 + 140.9317606630898.*z)) + ...
        y.*(674.819060538734 + z.*(-1069.887337245828 + (530.4484299696 - 158.40030944233638.*z).*z) + ...
        y.*(-409.779283929806 + y.*(149.452282277512 - 218.92375140095282.*z) + ...
        (681.370187043564 - 133.5392811916956.*z).*z))));
    
    gibbs = (g03 + g08).*1e-16;
    % Note. This is the second derivative of the Gibbs function with respect to
    % pressure, measured in Pa.  This derivative has units of (J/kg) (Pa^-2).
    
end

end