import xarray as xr
import numpy as np

da = xr.open_zarr("test2.zarr", consolidated=False)
print(da)
print(da.zda.values) 

#with open("test.zarr/zda/0","rb") as f:
#    data=np.fromfile(f, dtype='float32')
#print(data, data.shape)
