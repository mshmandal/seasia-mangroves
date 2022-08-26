# Sundarbans GMW2020

r1=rast("D:/bigdata/GMW-all_2020_v3.0/gmw_v3_2020/GMW_N22E088_2020_v3.tif")
r2=rast("D:/bigdata/GMW-all_2020_v3.0/gmw_v3_2020/GMW_N22E089_2020_v3.tif")
r3=rast("D:/bigdata/GMW-all_2020_v3.0/gmw_v3_2020/GMW_N23E089_2020_v3.tif")
r4=rast("D:/bigdata/GMW-all_2020_v3.0/gmw_v3_2020/GMW_N23E088_2020_v3.tif")

r=mosaic(r1,r2,r3,r4)

plot(r,col="red")
