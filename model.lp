maximize
obj: 1015 share_ha_B1,winter_wheat_ + 931 share_ha_B2,winter_wheat_ + 784 share_ha_B3,winter_wheat_ + 1099 share_ha_B4,winter_wheat_ + 816.0000000000002 share_ha_B1,winter_barley_ + 757.5 share_ha_B2,winter_barley_ + 679.5 share_ha_B3,winter_barley_ + 777 share_ha_B4,winter_barley_ + 992.5 share_ha_B1,grain_maize_ + 895 share_ha_B2,grain_maize_ + 1090 share_ha_B3,grain_maize_ + 661.0000000000002 share_ha_B4,grain_maize_ + 38 yield_contract_t + 22 yield_surplus_t + 4120 share_ha_B1,potato_ + 3640 share_ha_B2,potato_ + 3800 share_ha_B3,potato_ + 760 share_ha_B4,potato_ + 554 share_ha_B1,field_beans_ + 467 share_ha_B2,field_beans_ + 351 share_ha_B3,field_beans_ + 496 share_ha_B4,field_beans_ - 19 hired_h_P1_spring_ - 19 hired_h_P2_early_summer_ - 21 hired_h_P3_late_summer_ - 24 hired_h_P4_autumn_ - 0.36 pumped_m3_P1_spring_ - 0.36 pumped_m3_P2_early_summer_ - 0.36 pumped_m3_P3_late_summer_ - 0.36 pumped_m3_P4_autumn_ - 1750 share_ha_B1,sugar_beet_ - 1750 share_ha_B2,sugar_beet_ - 1750 share_ha_B3,sugar_beet_ - 1750 share_ha_B4,sugar_beet_ - 90 share_ha_B1,cover_fallow_ - 90 share_ha_B2,cover_fallow_ - 90 share_ha_B3,cover_fallow_ - 90 share_ha_B4,cover_fallow_
subject to
c1_2: 1 share_ha_B1,winter_wheat_ + 1 share_ha_B2,winter_wheat_ + 1 share_ha_B3,winter_wheat_ + 1 share_ha_B4,winter_wheat_ <= 32
c2_1: 1 share_ha_B1,winter_barley_ + 1 share_ha_B2,winter_barley_ + 1 share_ha_B3,winter_barley_ + 1 share_ha_B4,winter_barley_ <= 32
c3_1: 1 share_ha_B1,grain_maize_ + 1 share_ha_B2,grain_maize_ + 1 share_ha_B3,grain_maize_ + 1 share_ha_B4,grain_maize_ <= 32
c4_1: 1 share_ha_B1,sugar_beet_ + 1 share_ha_B2,sugar_beet_ + 1 share_ha_B3,sugar_beet_ + 1 share_ha_B4,sugar_beet_ <= 32
c5_1: 1 share_ha_B1,potato_ + 1 share_ha_B2,potato_ + 1 share_ha_B3,potato_ + 1 share_ha_B4,potato_ <= 32
c6_1: 1 share_ha_B1,field_beans_ + 1 share_ha_B2,field_beans_ + 1 share_ha_B3,field_beans_ + 1 share_ha_B4,field_beans_ <= 32
c7_1: 1 share_ha_B1,cover_fallow_ + 1 share_ha_B2,cover_fallow_ + 1 share_ha_B3,cover_fallow_ + 1 share_ha_B4,cover_fallow_ <= 80
c8_1: 1 pumped_m3_P1_spring_ + 1 pumped_m3_P2_early_summer_ + 1 pumped_m3_P3_late_summer_ + 1 pumped_m3_P4_autumn_ <= 10000
c1_1: 1 share_ha_B1,cover_fallow_ + 1 share_ha_B2,cover_fallow_ + 1 share_ha_B3,cover_fallow_ + 1 share_ha_B4,cover_fallow_ >= 0.04
c1: 1 share_ha_B1,winter_wheat_ + 1 share_ha_B1,winter_barley_ + 1 share_ha_B1,grain_maize_ + 1 share_ha_B1,sugar_beet_ + 1 share_ha_B1,potato_ + 1 share_ha_B1,field_beans_ + 1 share_ha_B1,cover_fallow_ = 26
c2: 1 share_ha_B2,winter_wheat_ + 1 share_ha_B2,winter_barley_ + 1 share_ha_B2,grain_maize_ + 1 share_ha_B2,sugar_beet_ + 1 share_ha_B2,potato_ + 1 share_ha_B2,field_beans_ + 1 share_ha_B2,cover_fallow_ = 22
c3: 1 share_ha_B3,winter_wheat_ + 1 share_ha_B3,winter_barley_ + 1 share_ha_B3,grain_maize_ + 1 share_ha_B3,sugar_beet_ + 1 share_ha_B3,potato_ + 1 share_ha_B3,field_beans_ + 1 share_ha_B3,cover_fallow_ = 18
c4: 1 share_ha_B4,winter_wheat_ + 1 share_ha_B4,winter_barley_ + 1 share_ha_B4,grain_maize_ + 1 share_ha_B4,sugar_beet_ + 1 share_ha_B4,potato_ + 1 share_ha_B4,field_beans_ + 1 share_ha_B4,cover_fallow_ = 14
c5: 85 share_ha_B1,sugar_beet_ + 81 share_ha_B2,sugar_beet_ + 76 share_ha_B3,sugar_beet_ + 72 share_ha_B4,sugar_beet_ - 1 yield_contract_t - 1 yield_surplus_t = 0
c6: 3 share_ha_B1,winter_wheat_ + 3 share_ha_B2,winter_wheat_ + 3 share_ha_B3,winter_wheat_ + 3 share_ha_B4,winter_wheat_ + 2.8 share_ha_B1,winter_barley_ + 2.8 share_ha_B2,winter_barley_ + 2.8 share_ha_B3,winter_barley_ + 2.8 share_ha_B4,winter_barley_ + 4 share_ha_B1,grain_maize_ + 4 share_ha_B2,grain_maize_ + 4 share_ha_B3,grain_maize_ + 4 share_ha_B4,grain_maize_ + 5.5 share_ha_B1,sugar_beet_ + 5.5 share_ha_B2,sugar_beet_ + 5.5 share_ha_B3,sugar_beet_ + 5.5 share_ha_B4,sugar_beet_ + 7 share_ha_B1,potato_ + 7 share_ha_B2,potato_ + 7 share_ha_B3,potato_ + 7 share_ha_B4,potato_ + 3.2 share_ha_B1,field_beans_ + 3.2 share_ha_B2,field_beans_ + 3.2 share_ha_B3,field_beans_ + 3.2 share_ha_B4,field_beans_ + 0.5 share_ha_B1,cover_fallow_ + 0.5 share_ha_B2,cover_fallow_ + 0.5 share_ha_B3,cover_fallow_ + 0.5 share_ha_B4,cover_fallow_ - 1 family_h_P1_spring_ - 1 hired_h_P1_spring_ = 0
c7: 1.5 share_ha_B1,winter_wheat_ + 1.5 share_ha_B2,winter_wheat_ + 1.5 share_ha_B3,winter_wheat_ + 1.5 share_ha_B4,winter_wheat_ + 1.2 share_ha_B1,winter_barley_ + 1.2 share_ha_B2,winter_barley_ + 1.2 share_ha_B3,winter_barley_ + 1.2 share_ha_B4,winter_barley_ + 2.5 share_ha_B1,grain_maize_ + 2.5 share_ha_B2,grain_maize_ + 2.5 share_ha_B3,grain_maize_ + 2.5 share_ha_B4,grain_maize_ + 3 share_ha_B1,sugar_beet_ + 3 share_ha_B2,sugar_beet_ + 3 share_ha_B3,sugar_beet_ + 3 share_ha_B4,sugar_beet_ + 6 share_ha_B1,potato_ + 6 share_ha_B2,potato_ + 6 share_ha_B3,potato_ + 6 share_ha_B4,potato_ + 1.8 share_ha_B1,field_beans_ + 1.8 share_ha_B2,field_beans_ + 1.8 share_ha_B3,field_beans_ + 1.8 share_ha_B4,field_beans_ + 0.3 share_ha_B1,cover_fallow_ + 0.3 share_ha_B2,cover_fallow_ + 0.3 share_ha_B3,cover_fallow_ + 0.3 share_ha_B4,cover_fallow_ - 1 family_h_P2_early_summer_ - 1 hired_h_P2_early_summer_ = 0
c8: 4 share_ha_B1,winter_wheat_ + 4 share_ha_B2,winter_wheat_ + 4 share_ha_B3,winter_wheat_ + 4 share_ha_B4,winter_wheat_ + 3.6 share_ha_B1,winter_barley_ + 3.6 share_ha_B2,winter_barley_ + 3.6 share_ha_B3,winter_barley_ + 3.6 share_ha_B4,winter_barley_ + 1.5 share_ha_B1,grain_maize_ + 1.5 share_ha_B2,grain_maize_ + 1.5 share_ha_B3,grain_maize_ + 1.5 share_ha_B4,grain_maize_ + 2 share_ha_B1,sugar_beet_ + 2 share_ha_B2,sugar_beet_ + 2 share_ha_B3,sugar_beet_ + 2 share_ha_B4,sugar_beet_ + 5 share_ha_B1,potato_ + 5 share_ha_B2,potato_ + 5 share_ha_B3,potato_ + 5 share_ha_B4,potato_ + 3 share_ha_B1,field_beans_ + 3 share_ha_B2,field_beans_ + 3 share_ha_B3,field_beans_ + 3 share_ha_B4,field_beans_ + 0.4 share_ha_B1,cover_fallow_ + 0.4 share_ha_B2,cover_fallow_ + 0.4 share_ha_B3,cover_fallow_ + 0.4 share_ha_B4,cover_fallow_ - 1 family_h_P3_late_summer_ - 1 hired_h_P3_late_summer_ = 0
c9: 3.5 share_ha_B1,winter_wheat_ + 3.5 share_ha_B2,winter_wheat_ + 3.5 share_ha_B3,winter_wheat_ + 3.5 share_ha_B4,winter_wheat_ + 3.2 share_ha_B1,winter_barley_ + 3.2 share_ha_B2,winter_barley_ + 3.2 share_ha_B3,winter_barley_ + 3.2 share_ha_B4,winter_barley_ + 5 share_ha_B1,grain_maize_ + 5 share_ha_B2,grain_maize_ + 5 share_ha_B3,grain_maize_ + 5 share_ha_B4,grain_maize_ + 7.5 share_ha_B1,sugar_beet_ + 7.5 share_ha_B2,sugar_beet_ + 7.5 share_ha_B3,sugar_beet_ + 7.5 share_ha_B4,sugar_beet_ + 18 share_ha_B1,potato_ + 18 share_ha_B2,potato_ + 18 share_ha_B3,potato_ + 18 share_ha_B4,potato_ + 2.5 share_ha_B1,field_beans_ + 2.5 share_ha_B2,field_beans_ + 2.5 share_ha_B3,field_beans_ + 2.5 share_ha_B4,field_beans_ + 0.5 share_ha_B1,cover_fallow_ + 0.5 share_ha_B2,cover_fallow_ + 0.5 share_ha_B3,cover_fallow_ + 0.5 share_ha_B4,cover_fallow_ - 1 family_h_P4_autumn_ - 1 hired_h_P4_autumn_ = 0
c10: 1 water_level_start_P1_spring_ = 9000
c11: 1 water_level_end_P4_autumn_ = 10000
c12: -1 water_level_end_P1_spring_ + 1 water_level_start_P2_early_summer_ = 0
c13: -1 water_level_end_P2_early_summer_ + 1 water_level_start_P3_late_summer_ = 0
c14: -1 water_level_end_P3_late_summer_ + 1 water_level_start_P4_autumn_ = 0
c15: 1 water_level_end_P1_spring_ - 1 water_level_start_P1_spring_ - 1 used_inflow_m3_P1_spring_ - 1 pumped_m3_P1_spring_ = 0
c16: 300 share_ha_B1,grain_maize_ + 300 share_ha_B2,grain_maize_ + 300 share_ha_B3,grain_maize_ + 300 share_ha_B4,grain_maize_ + 350 share_ha_B1,sugar_beet_ + 350 share_ha_B2,sugar_beet_ + 350 share_ha_B3,sugar_beet_ + 350 share_ha_B4,sugar_beet_ + 520 share_ha_B1,potato_ + 520 share_ha_B2,potato_ + 520 share_ha_B3,potato_ + 520 share_ha_B4,potato_ + 120 share_ha_B1,field_beans_ + 120 share_ha_B2,field_beans_ + 120 share_ha_B3,field_beans_ + 120 share_ha_B4,field_beans_ + 1 water_level_end_P2_early_summer_ - 1 water_level_start_P2_early_summer_ - 1 used_inflow_m3_P2_early_summer_ - 1 pumped_m3_P2_early_summer_ = 0
c17: 200 share_ha_B1,grain_maize_ + 200 share_ha_B2,grain_maize_ + 200 share_ha_B3,grain_maize_ + 200 share_ha_B4,grain_maize_ + 250 share_ha_B1,sugar_beet_ + 250 share_ha_B2,sugar_beet_ + 250 share_ha_B3,sugar_beet_ + 250 share_ha_B4,sugar_beet_ + 480 share_ha_B1,potato_ + 480 share_ha_B2,potato_ + 480 share_ha_B3,potato_ + 480 share_ha_B4,potato_ + 60 share_ha_B1,field_beans_ + 60 share_ha_B2,field_beans_ + 60 share_ha_B3,field_beans_ + 60 share_ha_B4,field_beans_ + 1 water_level_end_P3_late_summer_ - 1 water_level_start_P3_late_summer_ - 1 used_inflow_m3_P3_late_summer_ - 1 pumped_m3_P3_late_summer_ = 0
c18: 1 water_level_end_P4_autumn_ - 1 water_level_start_P4_autumn_ - 1 used_inflow_m3_P4_autumn_ - 1 pumped_m3_P4_autumn_ = 0
Bounds
share_ha_B1,winter_wheat_ >= 0
share_ha_B2,winter_wheat_ >= 0
share_ha_B3,winter_wheat_ >= 0
share_ha_B4,winter_wheat_ >= 0
share_ha_B1,winter_barley_ >= 0
share_ha_B2,winter_barley_ >= 0
share_ha_B3,winter_barley_ >= 0
share_ha_B4,winter_barley_ >= 0
share_ha_B1,grain_maize_ >= 0
share_ha_B2,grain_maize_ >= 0
share_ha_B3,grain_maize_ >= 0
share_ha_B4,grain_maize_ >= 0
share_ha_B1,sugar_beet_ >= 0
share_ha_B2,sugar_beet_ >= 0
share_ha_B3,sugar_beet_ >= 0
share_ha_B4,sugar_beet_ >= 0
share_ha_B1,potato_ >= 0
share_ha_B2,potato_ >= 0
share_ha_B3,potato_ >= 0
share_ha_B4,potato_ >= 0
share_ha_B1,field_beans_ >= 0
share_ha_B2,field_beans_ >= 0
share_ha_B3,field_beans_ >= 0
share_ha_B4,field_beans_ >= 0
share_ha_B1,cover_fallow_ >= 0
share_ha_B2,cover_fallow_ >= 0
share_ha_B3,cover_fallow_ >= 0
share_ha_B4,cover_fallow_ >= 0
yield_contract_t = 900
yield_surplus_t >= 0
0 <= family_h_P1_spring_ <= 520
0 <= family_h_P2_early_summer_ <= 470
0 <= family_h_P3_late_summer_ <= 500
0 <= family_h_P4_autumn_ <= 420
0 <= hired_h_P1_spring_ <= 200
0 <= hired_h_P2_early_summer_ <= 200
0 <= hired_h_P3_late_summer_ <= 250
0 <= hired_h_P4_autumn_ <= 125
0 <= water_level_end_P1_spring_ <= 13000
0 <= water_level_end_P2_early_summer_ <= 13000
0 <= water_level_end_P3_late_summer_ <= 13000
0 <= water_level_end_P4_autumn_ <= 13000
0 <= water_level_start_P1_spring_ <= 13000
0 <= water_level_start_P2_early_summer_ <= 13000
0 <= water_level_start_P3_late_summer_ <= 13000
0 <= water_level_start_P4_autumn_ <= 13000
0 <= used_inflow_m3_P1_spring_ <= 5500
0 <= used_inflow_m3_P2_early_summer_ <= 2000
0 <= used_inflow_m3_P3_late_summer_ <= 1200
0 <= used_inflow_m3_P4_autumn_ <= 9000
0 <= pumped_m3_P1_spring_ <= 5000
0 <= pumped_m3_P2_early_summer_ <= 5000
0 <= pumped_m3_P3_late_summer_ <= 5000
0 <= pumped_m3_P4_autumn_ <= 5000
End
