

local _, addon = ...;

local Database = addon.Database;
local Character = {};
local Tradeskills = addon.Tradeskills;
local L = addon.Locales;


--will use a specID as found from spellbook tabs-1 (ignore general) and then get the spec name from this table
--for display the name value can be used to grab the locale
local classData = {
    -- DEATHKNIGHT = { 
    --     specializations={'Frost','Blood','Unholy'} 
    -- },
    DRUID = { 
        specializations={'Balance', 'Cat' ,'Bear', 'Restoration',}
    },
    HUNTER = { 
        specializations={'Beast Master', 'Marksmanship','Survival',} 
    },
    MAGE = { 
        specializations={'Arcane', 'Fire','Frost',} 
    },
    PALADIN = { 
        specializations={'Holy','Protection','Retribution',} 
    },
    PRIEST = { 
        specializations={'Discipline','Holy','Shadow',} 
    },
    ROGUE = { 
        specializations={'Assassination','Combat','Subtlety',} -- outlaw = combat
    },
    SHAMAN = { 
        specializations={'Elemental', 'Enhancement', 'Restoration'} 
    },
    WARLOCK = {  
        specializations={'Affliction','Demonology','Destruction',} 
    },
    WARRIOR = { 
        specializations={'Arms','Fury','Protection',} 
    },
}

local raceFileStringToId = {
    Human = 1,
    Orc = 2,
    Dwarf = 3,
    NightElf = 4,
    Scourge = 5,
    Tauren = 6,
    Gnome = 7,
    Troll = 8,
    Goblin = 9,
    BloodElf = 10,
    Draenei = 11,

    Worgen = 22,
    Pandaren = 24,
    PandarenAlliance = 25,
    PandarenHorde = 26,
}

function Character:GetGuid()
    return self.data.guid;
end

function Character:SetGuid(guid)
    self.data.guid = guid;
end

function Character:SetOnlineStatus(info, broadcast)
    self.data.onlineStatus = info;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetOnlineStatus", "onlineStatus")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "onlineStatus", self.data.name))
end

function Character:GetOnlineStatus()
    return self.data.onlineStatus;
end


function Character:SetName(name)
    self.data.name = name;
end

function Character:GetName()
    return self.data.name;
end

function Character:SetRank(index)
    if self.data.rank ~= index then
        self.data.rank = index;
        addon:TriggerEvent("Character_OnDataChanged", self)
        addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "rank", self.data.name))
    end
end

function Character:GetRank()
    return self.data.rank;
end

function Character:SetLevel(level, broadcast)
    if self.data.level ~= level then
        self.data.level = level;
        addon:TriggerEvent("Character_OnDataChanged", self)
        if broadcast then
            addon:TriggerEvent("Character_BroadcastChange", self, "SetLevel", "level")
        end
        addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "level", self.data.name))
    end
end

function Character:GetLevel()
    return self.data.level;
end


function Character:SetRace(race, broadcast)
    if self.data.race ~= race then
        self.data.race = race;
        addon:TriggerEvent("Character_OnDataChanged", self)
        if broadcast then
            addon:TriggerEvent("Character_BroadcastChange", self, "SetRace", "race")
        end
        addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "race", self.data.name))
    end
end

function Character:GetRace()
    local raceInfo = C_CreatureInfo.GetRaceInfo(self.data.race)
    return raceInfo;
end


function Character:SetClass(class)
    self.data.class = class;
end

function Character:GetClass()
    return self.data.class;
end


function Character:SetGender(gender, broadcast)
    if self.data.gender ~= gender then
        self.data.gender = gender;
        addon:TriggerEvent("Character_OnDataChanged", self)
        if broadcast then
            addon:TriggerEvent("Character_BroadcastChange", self, "SetGender", "gender")
        end
        addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "gender", self.data.name))
    end
end

function Character:GetGender()
    return self.data.gender;
end


function Character:SetPublicNote(note, broadcast)
    if self.data.publicNote ~= note then
        self.data.publicNote = note;
        addon:TriggerEvent("Character_OnDataChanged", self)
        if broadcast then
            addon:TriggerEvent("Character_BroadcastChange", self, "SetPublicNote", "publicNote")
        end
        addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "public note", self.data.name))
    end
end

function Character:GetPublicNote()
    return self.data.publicNote;
end

function Character:SetContainers(containers, broadcast)
    self.data.containers = containers;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetContainers", "containers")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "containers", self.data.name))
end

function Character:GetContainers()
    return self.data.containers;
end

function Character:GetSpecializations()
    if type(self.data.class) == "number" then
        local _, class = GetClassInfo(self.data.class);
        return classData[class].specializations;
    end
    return {}
end

function Character:SetSpec(spec, specID, broadcast)
    local k;
    if spec == "primary" then
        self.data.mainSpec = specID;
        k = "mainSpec";
    elseif spec == "secondary" then
        self.data.offSpec = specID;
        k = "offSpec";
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetSpec", spec, specID)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "spec", self.data.name))
end

function Character:GetSpec(spec)
    if type(self.data.class) == "number" then
        local _, class = GetClassInfo(self.data.class);
        if spec == "primary" then
            local specName = classData[class].specializations[self.data.mainSpec]
            return L[specName], specName, self.data.mainSpec;
        elseif spec == "secondary" then
            local specName = classData[class].specializations[self.data.offSpec]
            return L[specName], specName, self.data.offSpec;
        end
    else

    end
end


function Character:SetSpecIsPvp(spec, isPvp)
    --print("set isPvp", spec, isPvp)
    if spec == "primary" then
        self.data.mainSpecIsPvP = isPvp;
    elseif spec == "secondary" then
        self.data.offSpecIsPvP = isPvp;
    end
    --addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetSpecIsPvp(spec)
    if spec == "primary" then
        return self.data.mainSpecIsPvP;
    elseif spec == "secondary" then
        return self.data.offSpecIsPvP;
    end
end


function Character:SetTradeskill(slot, id, broadcast)
    local k;
    if slot == 1 then
        self.data.profession1 = id;
        k = "profession1"
    elseif slot == 2 then
        self.data.profession2 = id;
        k = "profession2"
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetTradeskill", k)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "tradeskill", self.data.name))
end

function Character:GetTradeskill(slot)
    if slot == 1 then
        return self.data.profession1;
    elseif slot == 2 then
        return self.data.profession2;
    end
end


function Character:SetTradeskillLevel(slot, level, broadcast)
    local k;
    if slot == 1 then
        self.data.profession1Level = level;
        k = "profession1Level"
    elseif slot == 2 then
        self.data.profession2Level = level;
        k = "profession2Level"
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetTradeskillLevel", k)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "tradeskill level", self.data.name))
end

function Character:GetTradeskillLevel(slot)
    if slot == 1 then
        return self.data.profession1Level;
    elseif slot == 2 then
        return self.data.profession2Level;
    end
end


function Character:SetTradeskillSpec(slot, spec, broadcast)
    local k
    if slot == 1 then
        self.data.profession1Spec = spec;
        k = "profession1Spec"
    elseif slot == 2 then
        self.data.profession2Spec = spec;
        k = "profession2Spec"
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetTradeskillSpec", k)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "tradeskill spec", self.data.name))
end

function Character:GetTradeskillSpec(slot)
    if slot == 1 then
        return self.data.profession1Spec;
    elseif slot == 2 then
        return self.data.profession2Spec;
    end
end


function Character:SetTradeskillRecipes(slot, recipes, broadcast)
    local k;
    if slot == 1 then
        self.data.profession1Recipes = recipes;
        k = "profession1Recipes"
    elseif slot == 2 then
        self.data.profession2Recipes = recipes;
        k = "profession2Recipes"
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self,"SetTradeskillRecipes", k)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "tradeskill recipes", self.data.name))
end

function Character:GetTradeskillRecipes(slot)
    if slot == 1 then
        return self.data.profession1Recipes;
    elseif slot == 2 then
        return self.data.profession2Recipes;
    end
end


function Character:SetCookingRecipes(recipes, broadcast)
    self.data.cookingRecipes = recipes;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetCookingRecipes", "cookingRecipes")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "cooking recipes", self.data.name))
end

function Character:GetCookingRecipes()
    return self.data.cookingRecipes;
end


function Character:CanCraftItem(item)

    --grab item tradeskill first
    if item.professionID == 185 then
        if type(self.data.firstAidRecipes) == "table" then
            for k, spellID in ipairs(self.data.cookingRecipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    elseif item.professionID == 129 then
        if type(self.data.firstAidRecipes) == "table" then
            for k, spellID in ipairs(self.data.firstAidRecipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    else
        if type(self.data.profession1Recipes) == "table" then
            for k, spellID in ipairs(self.data.profession1Recipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    
        if type(self.data.profession2Recipes) == "table" then
            for k, spellID in ipairs(self.data.profession2Recipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    end
    return false;
end


function Character:SetCookingLevel(level, broadcast)
    self.data.cookingLevel = level;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetCookingLevel", "cookingLevel")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "cooking level", self.data.name))
end

function Character:GetCookingLevel()
    return self.data.cookingLevel;
end


function Character:SetFishingLevel(level, broadcast)
    self.data.fishingLevel = level;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetFishingLevel", "fishingLevel")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "fishing level", self.data.name))
end

function Character:GetFishingLevel()
    return self.data.fishingLevel;
end

function Character:SetFirstAidRecipes(recipes, broadcast)
    self.data.firstAidRecipes = recipes;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetFirstAidRecipes", "firstAidRecipes")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "first aid recipes", self.data.name))
end

function Character:GetFirstAidRecipes()
    return self.data.firstAidRecipes;
end

function Character:SetFirstAidLevel(level, broadcast)
    self.data.firstAidLevel = level;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetFirstAidLevel", "firstAidLevel")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "first aid level", self.data.name))
end

function Character:GetFirstAidLevel()
    return self.data.firstAidLevel;
end


function Character:SetProfileDob(timeStamp)
    self.data.profile.dob = timeStamp;
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetProfileDob()
    if not self.data.profile then
        return "";
    end
    return self.data.profile.dob;
end


function Character:SetProfileName(name)
    self.data.profile.name = name;
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetProfileName()
    if not self.data.profile then
        return "";
    end
    return self.data.profile.name;
end


function Character:SetProfileBio(bio)
    self.data.profile.bio = bio;
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetProfileBio()
    if not self.data.profile then
        return "";
    end
    return self.data.profile.bio;
end

--used to set dispaly text and detect when changes occur
function Character:GetProfile()
    local t = {};
    if not self.data.profile then
        return false;
    end
    t.name = self.data.profile.name;
    t.bio = self.data.profile.bio;
    t.mainSpec = self.data.mainSpec;
    t.mainSpecIsPvp = self.data.mainSpecIsPvP;
    t.offSpec = self.data.offSpec;
    t.offSpecIsPvP = self.data.offSpecIsPvP;
    t.mainCharacter = self.data.mainCharacter;
    t.alts = self.data.alts;
    return t;
end

function Character:SetTalents(spec, talents, broadcast)
    if (#talents > 0) then
        self.data.talents[spec] = talents;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetTalents", "talents", spec)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "talents", self.data.name))
end

function Character:GetTalents(spec)
    if self.data.talents[spec] then
        return self.data.talents[spec];
    end
end


-- function Character:SetGlyphs(spec, glyphs)

--     if (#glyphs > 0) then
--         self.data.glyphs[spec] = glyphs;
--     else
--         --print("glyphs", spec, "no data")
--     end
-- end

-- function Character:GetGlyphs(spec)
--     if self.data.glyphs[spec] then
--         return self.data.glyphs[spec];
--     end
-- end


function Character:SetInventory(set, inventory, broadcast)
    self.data.inventory[set] = inventory;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetInventory", "inventory", set)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "inventory (gear)", self.data.name))
end

function Character:GetInventory(set)
    return self.data.inventory[set] or {};
end

function Character:SetAuras(set, res, broadcast)
    self.data.auras[set] = res;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetAuras", "auras", set)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "auras", self.data.name))
end

function Character:GetAuras(set)
    return self.data.auras[set] or {};
end

function Character:SetResistances(set, res, broadcast)
    self.data.resistances[set] = res;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetResistances", "resistances", set)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "resistances", self.data.name))
end

function Character:GetResistances(set)
    return self.data.resistances[set] or {};
end

function Character:SetPaperdollStats(set, stats, broadcast)
    self.data.paperDollStats[set] = stats;
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetPaperdollStats", "paperDollStats", set)
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "stats", self.data.name))
end

function Character:GetPaperdollStats(set)
    if self.data.paperDollStats[set] then
        return self.data.paperDollStats[set] or {};
    end
end


function Character:SetMainCharacter(main, broadcast)
    self.data.mainCharacter = main;
    if Database.db.myCharacters then
        for name, val in pairs(Database.db.myCharacters) do
            val = false;

            --do not call this func in here just set the data directly
            if addon.characters and addon.characters[name] then
                addon.characters[name].data.mainCharacter = self.data.mainCharacter
            end
        end
        Database.db.myCharacters[self.data.name] = true;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    if broadcast then
        addon:TriggerEvent("Character_BroadcastChange", self, "SetMainCharacter", "mainCharacter")
    end
    addon:TriggerEvent("StatusText_OnChanged", string.format(" set %s for %s", "main character", self.data.name))
end

function Character:GetMainCharacter()
    return self.data.mainCharacter;
end

function Character:SetAlts(alts)
    self.data.alts = alts;
    addon:TriggerEvent("Character_OnDataChanged", self, "alts")
end

function Character:GetAlts()
    return self.data.alts;
end


function Character:AddNewAlt(guid)
    table.insert(self.data.alts, guid)
end

function Character:RemoveAlt(guid)
    local i;
    for k, _guid in ipairs(self.data.alts) do
        if _guid == guid then
            i = k;
        end
    end
    if type(i) == "number" then
        table.remove(self.data.alts, i)
    end
end

function Character:GetTradeskillIcon(slot)
    if type(self.data["profession"..slot]) == "number" then
        return Tradeskills:TradeskillIDToAtlas(self.data["profession"..slot])
    end
    return "questlegendaryturnin";
end

function Character:GetProfileAvatar()
    if type(self.data.race) == "number" and type(self.data.gender) == "number" then
        local raceInfo = C_CreatureInfo.GetRaceInfo(self.data.race)
        local gender = (self.data.gender == 3) and "female" or "male" --GetPlayerInfoByGUID returns 2=MALE 3=FEMALE
        return string.format("raceicon-%s-%s", raceInfo.clientFileString:lower(), gender)
    else

    end
    return "questlegendaryturnin"
end

function Character:GetClassSpecAtlasInfo()
    if type(self.data.class) == "number" then
        local _, class = GetClassInfo(self.data.class)
        if class then
            local t = {}
            for k, s in ipairs(classData[class].specializations) do
                if s == "Beast Master" then
                    s = "BeastMastery";
                end
                if s == "Cat" then
                    s = "Feral";
                end
                if s == "Bear" then
                    s = "Guardian";
                end
                if s == "Combat" then
                    s = "Outlaw";
                end
                table.insert(t, string.format("GarrMission_ClassIcon-%s-%s", class, s))
            end
            return t
        end
    end
    return {}
end

function Character:GetClassSpecAtlasName(spec)

    if type(self.data.class) == "number" then
        local _, class = GetClassInfo(self.data.class)

        if not spec then
            return string.format("classicon-%s", class):lower()
        else
            
            local s;
            if spec == "primary" then
                s = classData[class].specializations[self.data.mainSpec]
            else
                s = classData[class].specializations[self.data.offSpec]
            end

            if s == "Beast Master" then
                s = "BeastMastery";
            end
            if s == "Cat" then
                s = "Feral";
            end
            if s == "Bear" then
                s = "Guardian";
            end
            if s == "Combat" then
                s = "Outlaw";
            end

            return string.format("GarrMission_ClassIcon-%s-%s", class, s)
        end
    end

    return "questlegendaryturnin";

end

-- function Character:RegisterCallbacks()
--     addon:RegisterCallback("Blizzard_OnTradeskillUpdate", self.Blizzard_OnTradeskillUpdate, self)
-- end


-- function Character:Blizzard_OnTradeskillUpdate(prof, recipes)

--     if self.data.guid == UnitGUID("player") then

--         if prof == 185 then
--             self:SetCookingRecipes(recipes)
--             return;
--         end

--         if prof == 129 then
--             self:SetFirstAidRecipes(recipes)
--             return
--         end

--         if prof == 356 then
            
--             return;
--         end

--         if self.data.profession1 == "-" then
--             self:SetTradeskill(1, prof);
--             self:SetTradeskillRecipes(1, recipes)
--             return;
--         else
--             if self.data.profession1 == prof then
--                 self:SetTradeskillRecipes(1, recipes)
--                 return;
--             end
--         end

--         if self.data.profession2 == "-" then
--             self:SetTradeskill(2, prof);
--             self:SetTradeskillRecipes(2, recipes)
--             return;
--         else
--             if self.data.profession2 == prof then
--                 self:SetTradeskillRecipes(2, recipes)
--                 return;
--             end
--         end

--     end
-- end


function Character:CreateFromData(data)
    --print(string.format("Created Character Obj [%s] at %s", data.name or "-", date('%H:%M:%S', time())))

    --lets crack player info
    if (data.race == false) or (data.gender == false) then
        self.ticker = C_Timer.NewTicker(1, function()
            local _, _, _, englishRace, sex = GetPlayerInfoByGUID(data.guid)
            if englishRace and sex then
                if addon.characters[data.name] then
                    addon.characters[data.name]:SetGender(sex)
                    addon.characters[data.name]:SetRace(raceFileStringToId[englishRace])
                    --print(string.format("Got race and gender info [%s] at %s", data.name or "-", date('%H:%M:%S', time())))
                    addon.characters[data.name].ticker:Cancel()
                end
            end
        end)
    end
    return Mixin({data = data}, self)
end



function Character:ResetData()
    local name = self.data.name;
    local guid = self.data.guid;
    self.data = {
        name = "",
        level = 0,
        class = "",
        race = "",
        gender = "",
        guid = guid,

        mainCharacter = false,
        publicNote = "",
        alts = {},

        mainSpec = 1,
        mainSpecIsPvP = false,
        offSpec = 2,
        offSpecIsPvP = false,

        profession1 = "-",
        profession2 = "-",
        profession1Level = 0,
        profession2Level = 0,
        profession1Recipes = {},
        profession2Recipes = {},
        profession1Spec = 0,
        profession2Spec = 0,

        cookingRecipes = {},

        cookingLevel = 0,
        firstAidLevel = 0,
        firstAidRecipes = {},
        fishingLevel = 0,

        talents = {
            primary = {},
            secondary = {},
        },
        glyphs = {
            primary = {},
            secondary = {},
        },

        inventory = {},
        currentInventory = {},

        rankName = "",
        profile = {
            dob = false,
            name = "",
            bio = "",
            avatar = false,
        },

        paperDollStats = {
            current = {},
            primary = {},
            secondary = {},
        },
        --CurrentPaperdollStats = {},

        onlineStatus = {
            isOnline = false,
            zone = "",
        }
    }
    if guid == UnitGUID("player") then
        addon:TriggerEvent("Character_OnDataChanged")
    end
    --addon.DEBUG("func", "Character:ResetData", string.format("reset data for %s", name))
end


addon.Character = Character;
