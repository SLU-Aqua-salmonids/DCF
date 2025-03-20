
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 

# Package DCF

<!-- badges: start -->
<!-- badges: end -->

Package DCF provides tools for various processing of DCF salmon data
Access sers electrofishing data, create maps, calculate parr densities
etc.

## Installation

You can install Package DCF from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("SLU-Aqua-salmonids/DCF")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(DCF)
## Display known rivers
names(efish_sites)
#>  [1] "Torneälven"      "Kalixälven"      "Råneälven"       "Åbyälven"       
#>  [5] "Byskeälven"      "Kågeälven"       "Rickleån"        "Sävarån"        
#>  [9] "Vindelälven"     "Öreälven"        "Lögdeälven"      "Ljungan"        
#> [13] "Testeboån"       "Emån"            "Mörrumsån"       "Alslövsån"      
#> [17] "Arödsån"         "Bratteforsån"    "Brattorpsån"     "Brostorpsån"    
#> [21] "Bäljane å"       "Bäveån"          "Edenbergaån"     "Enningdalsälven"
#> [25] "Fageredsån"      "Forsån"          "Fylleån"         "Grönån"         
#> [29] "Himleån"         "Hämmensån"       "Högvadsån"       "Kungsbackaån"   
#> [33] "Kynne älv"       "Lindomeån"       "Långevallsälven" "Löftaån"        
#> [37] "Munkedalsälven"  "Nissan"          "Pinnån"          "Rolfsån"        
#> [41] "Rönne å"         "Rördalsån"       "Rössjöholmsån"   "Sennan"         
#> [45] "Slissån"         "Smedjeån"        "Sollumsån"       "Stensån"        
#> [49] "Storån"          "Strömsån"        "Surtan"          "Suseån"         
#> [53] "Säveån"          "Sörån"           "Tvååkers kanal"  "Törlan"         
#> [57] "Vessingeån"      "Viskan"          "Vättlandsån"     "Ätran"          
#> [61] "Örekilsälven"
# Print table of known sites in river Rickleån
sites <- dcf_known_efish_sites("Rickleån")
knitr::kable(sites)
```

| name                 | xkoorlok | ykoorlok | section         | area | used | since | Comment |
|:---------------------|---------:|---------:|:----------------|-----:|:-----|------:|:--------|
| Nättingforsen        |   711897 |   175020 | Nedan Bruksf.   | 15.0 | TRUE |     0 | NA      |
| Gammströmmen         |   712025 |   175000 | Nedan Bruksf.   | 15.0 | TRUE |     0 | NA      |
| Laxbacksforsen       |   712460 |   174705 | Nedan Bruksf.   | 15.0 | TRUE |     0 | NA      |
| Åströmsforsen        |   712520 |   174650 | Nedan Bruksf.   | 15.0 | TRUE |     0 | NA      |
| Böle                 |   712567 |   174556 | Nedan Bruksf.   | 15.0 | TRUE |     0 | NA      |
| Fiskegränsen         |   712625 |   174580 | Nedan Bruksf.   | 15.0 | TRUE |     0 | NA      |
| Johanneslund         |   712675 |   174566 | Nedan Bruksf.   | 15.0 | TRUE |     0 | NA      |
| Isakfäbodforsen övre |   713322 |   174119 | Ovan Fredriksf. | 16.8 | TRUE |  2018 | NA      |
| Tjärdalsforsen       |   713426 |   174010 | Ovan Fredriksf. | 16.8 | TRUE |  2018 | NA      |
| Faranforsen nedre    |   713503 |   173933 | Ovan Fredriksf. | 16.8 | TRUE |  2018 | NA      |
| Faranforsen övre     |   713511 |   173898 | Ovan Fredriksf. | 16.8 | TRUE |  2018 | NA      |
| Siknäs festplats     |   713562 |   173797 | Ovan Fredriksf. | 16.8 | TRUE |  2018 | NA      |
| Kvarnforsen          |   713615 |   173535 | Ovan Fredriksf. | 16.8 | TRUE |  2020 | NA      |

``` r
catch <- dcf_get_efish_data(river = "Rickleån", year = 2024)
head(catch)
#>                   name xkoorlok ykoorlok         section area used since
#> 1        Nättingforsen   711897   175020   Nedan Bruksf. 15.0 TRUE     0
#> 2       Laxbacksforsen   712460   174705   Nedan Bruksf. 15.0 TRUE     0
#> 3        Åströmsforsen   712520   174650   Nedan Bruksf. 15.0 TRUE     0
#> 4 Isakfäbodforsen övre   713322   174119 Ovan Fredriksf. 16.8 TRUE  2018
#> 5       Tjärdalsforsen   713426   174010 Ovan Fredriksf. 16.8 TRUE  2018
#> 6     Faranforsen övre   713511   173898 Ovan Fredriksf. 16.8 TRUE  2018
#>   Comment haronr vattendrag                lokal fiskedatum  syfte hoh lax0 lax
#> 1      NA  24000   Rickleån        Nättingforsen   20240923 Nö-lax   2  1.7 4.1
#> 2      NA  24000   Rickleån       Laxbacksforsen   20240923 Nö-lax  17 14.3 4.6
#> 3      NA  24000   Rickleån        Åströmsforsen   20240923 Nö-lax  20  9.0 3.3
#> 4      NA  24000   Rickleån Isakfäbodforsen övre   20240925 Nö-lax  61  0.0 0.0
#> 5      NA  24000   Rickleån       Tjärdalsforsen   20240925 Nö-lax  64 21.9 4.5
#> 6      NA  24000   Rickleån     Faranforsen övre   20241002 Nö-lax  80 15.0 2.5
#>   lax0ber laxber lax0pval laxpval öring0 öring örin0ber öringber öri0pval
#> 1       1      1     0.45    0.55    1.6   0.0        1       -9     0.48
#> 2       3      3     0.83    0.98    1.9   1.1        3        1     0.79
#> 3       1      1     0.45    0.55    0.8   0.0        1       -9     0.48
#> 4      NA     NA       NA    0.00    2.6   0.0        1       -9     0.48
#> 5       1      1     0.45    0.55    5.1   0.0        1       -9     0.48
#> 6       3      3     0.62    0.99    0.6   1.5        1        3     0.86
#>   örinpval antutfis metod bredd langd fished_area
#> 1     0.00        1  Kval    31    21         132
#> 2     0.91        3 Kvant    27    32         202
#> 3     0.00        1  Kval    39    26         272
#> 4     0.00        1  Kval    28    27          81
#> 5     0.00        1  Kval    38    27          81
#> 6     0.98        3 Kvant    36    24         205
```
