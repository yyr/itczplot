; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, February 20 2019

load "$nsc/resources.ncl"
load "$nsc/plot.ncl"

begin
  fin = "./precip.mon.ltm.nc"
  f = addfile(fin, "r")

  ; list_filevars(f)
  ; exit
  p = f->precip(5,:,:)
  lat = f->lat
  lon = f->lon

  ; print(lat)
  ; exit


  dims = dimsizes(p)
  nlons = dims(1)

  lc = new(nlons, integer)
  lt = ispan(0, nlons - 1, 1)
  do it = 0, 143, 1
    lc(it) = maxind(p(:,it))
    ; print(lon(it) + "  " + lat(lc(it)))
  end do

  ill =   lat(lc)
  ; exit


  printMinMax(p, True)

  wks = gsn_open_wks("pdf", "line_itcz")
  gsn_define_colormap(wks,"WhiteBlue") ; select color map

  res = True ; options desired
  res@gsnLeftString = ""
  res@gsnRightString = "JAN"
  res@gsnCenterString = "ITCZ"

  res@cnFillOn = True
  res@gsnSpreadColors=True
  res@cnLinesOn = False
  res@cnLineLabelsOn = False

  res = set_res_cn(res)

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF = 0
  res@cnMaxLevelValF =  18.
  res@cnLevelSpacingF = .5

  ;; lablebar
  res@lbOrientation = "vertical"
  res@lbLabelStride = 2

  ; res@gsnDraw                   = False                  ; don't draw
  res@gsnFrame                  = False                  ; don't advance frame
  ; res = set_res_no_margin(res)
  res = set_res_tm_size(res)

  plot = gsn_csm_contour_map(wks,p(:,:),res)

  gsres             = True
  gsres@gsLineColor = "blue"
  pl = gsn_add_polyline(wks,plot,lon,ill,gsres)
  draw(wks)
  frame(wks)
end
