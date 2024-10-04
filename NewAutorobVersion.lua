-- List of target objects to search for
local targetObjects = {
    "Cash",
    "CashRegister",
    "DiamondBox",
    "Laptop",
    "Phone",
    "Luggage",
    "ATM",
    "TV",
    "Safe"
}

-- Function to search for objects in the workspace
function searchForObjects()
    local foundObjects = {}
    for _, objectName in ipairs(targetObjects) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == objectName then
                table.insert(foundObjects, obj)
            end
        end
    end
    return foundObjects
end

-- Function to fly to a target position using Humanoid:MoveTo()
function flyToPosition(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Command the Humanoid to move to the target position
    humanoid:MoveTo(position)

    -- Wait until the character is close to the target position
    while (character.HumanoidRootPart.Position - position).magnitude > 5 do
        wait(0.1)
    end
end

-- Function to trigger RemoteEvent when at the object using FireServer
function triggerEvent(object)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Loop through all descendants to find RemoteEvent
    for _, descendant in pairs(object:GetDescendants()) do
        if descendant:IsA("RemoteEvent") and descendant.Parent:IsA("Part") then
            -- Check if the player is close enough to the object (within 20 studs)
            if (humanoidRootPart.Position - descendant.Parent.Position).magnitude < 20 then
                -- Trigger the RemoteEvent
                descendant:FireServer()
                print("Triggered RemoteEvent for: " .. object.Name)
            end
        end
    end
end

-- Main loop to search, fly, and trigger events
local objects = searchForObjects()
for _, obj in ipairs(objects) do
    print("Found object: " .. obj.Name)
    flyToPosition(obj.Position)  -- Fly to the object's position

    wait(1)  -- Wait at the object for a second

    triggerEvent(obj)  -- Trigger any event associated with the object
end
