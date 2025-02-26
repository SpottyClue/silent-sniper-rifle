local e = FindMetaTable("Entity")
local p = FindMetaTable("Player")

local Fire = e.Fire
local CreateRagdoll = p.CreateRagdoll
local KillSilent = p.KillSilent

SWEP.Author = "1999"
SWEP.Category = "1999's Weapons (Admin)"
SWEP.PrintName = "Silent Sniper Rifle"

SWEP.ViewModelFOV		= 57
SWEP.ViewModel			= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Spawnable = true 
SWEP.AdminOnly = true

SWEP.UseHands = true
SWEP.DrawAmmo = false

SWEP.Primary.Ammo		= ""
SWEP.Secondary.Ammo		= ""

function SWEP:Initialize()
    self:SetWeaponHoldType("ar2")
end

function SWEP:AdjustMouseSensitivity()
    if self.Owner:GetFOV() < 35 then
	    return 0.23
	    else
	    return 1
	end
end

function SWEP:FireAnimationEvent(pos,ang,event,options)
    return true
end

local function shootBullet(self)
    local ply = self:GetOwner()
    for k, v in pairs(ents.FindAlongRay(ply:GetShootPos(), ply:GetEyeTrace().HitPos, Vector(-5,-5,-5), Vector(5,5,5))) do
		if IsValid(v) and (v:IsNPC() or v:IsNextBot() and (v ~= ply) ) then
		    Fire(v, "Kill")
			else
			if v:IsPlayer() and not v:GetOwner()==self.Owner then
			    CreateRagdoll(v)
				KillSilent(v)
			end
		end
	end
	self:ShootEffects()
	self:SetNextPrimaryFire(CurTime() + 1.3)
	ply:ViewPunch(Angle(math.Rand(-0.5,-0.5)))
end

function SWEP:PrimaryAttack()
    shootBullet(self)
end

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()
    if not SERVER then return end
    if (zoom == 0) then
        ply:SetFOV(30, 0.1)
		ply:EmitSound("Default.Zoom")
        zoom = 1
    else
        if (zoom == 1) then
            ply:SetFOV(10, 0.1)
			ply:EmitSound("Default.Zoom")
            zoom = 2
        else
            ply:SetFOV(0, 0.1)
			ply:EmitSound("Default.Zoom")
            zoom = 0
        end
    end
end