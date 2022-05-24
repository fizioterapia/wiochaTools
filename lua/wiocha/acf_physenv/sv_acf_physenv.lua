local function acf_set_phys()
	local tbl = physenv.GetPerformanceSettings()
	tbl.MaxAngularVelocity = 30000
	tbl.MaxVelocity = 20000

	physenv.SetPerformanceSettings(tbl)
end
hook.Add("InitPostEntity", "wiochaTools::ACFPHYS", acf_set_phys)
