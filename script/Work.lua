local HundredHardDash     = Instance.new('Part');
HundredHardDash.Parent    = workspace;
HundredHardDash.Name      = '+AlrightBud';
HundredHardDash.CFrame    = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1000,0)
HundredHardDash.Size     = Vector3.new(500000, 4, 500000)
HundredHardDash.Anchored = true
HundredHardDash.Transparency = 1

local YourCar = function()
    local Car = nil;
    for i,v in pairs(workspace.Vehicles:GetChildren()) do
        if (v:FindFirstChild'Server' and v.Server:FindFirstChild'Player' and v.Server.Player.Value == game.Players.LocalPlayer) then
            Car = v;
        end
    end;
    return Car
end;

local Customer = function(car)
    local Target = nil;
    for i,v in pairs(workspace.NewCustomers:GetChildren()) do
        if car and v:FindFirstChild'Part' and v.Part:GetAttribute('Rating') >= RatingTarget and v.Part:GetAttribute('Rating') <= HighestRatingTarget then
            Target = v;
        end
    end
    return Target
end;

while true do
    local PlayerCar = YourCar();
    if PlayerCar and PlayerCar:FindFirstChild'REAL' and PlayerCar.REAL:FindFirstChild'DRIFT' then
        
        local TargetCustomer = Customer(PlayerCar);
        if TargetCustomer and TargetCustomer:FindFirstChild'Part' and not workspace.ParkingMarkers:FindFirstChild'destinationPart' then
            PlayerCar:PivotTo(TargetCustomer.Part.CFrame)
            
            if (PlayerCar.REAL.DRIFT.Position - TargetCustomer.Part.Position).Magnitude <= 10 then
                
                game.VirtualInputManager:SendKeyEvent(1, Enum.KeyCode.R, 0, game)
                if workspace.ParkingMarkers:FindFirstChild'destinationPart' then
                    game.VirtualInputManager:SendKeyEvent(0, Enum.KeyCode.R, 0, game)
                end
            end
        end;
        
        if workspace.ParkingMarkers:FindFirstChild'destinationPart' then
            local Destination = workspace.ParkingMarkers.destinationPart;
            
            HundredHardDash.CFrame = Destination.CFrame * CFrame.new(0,0,0)
            
            if (PlayerCar.REAL.DRIFT.Position - Destination.Position).Magnitude >= 20 then
                PlayerCar:PivotTo(HundredHardDash.CFrame * CFrame.new(0,0,0))
                game.VirtualInputManager:SendKeyEvent(1, Enum.KeyCode.W, 0, game)
            end
            
            task.wait(5)
            task.spawn(function()
                if PlayerCar and PlayerCar:FindFirstChild'REAL' and PlayerCar.REAL:FindFirstChild'DRIFT' then
                    PlayerCar:PivotTo(Destination.CFrame * CFrame.new(0,0,9))
                    game.VirtualInputManager:SendKeyEvent(0, Enum.KeyCode.W, 0, game)
                    repeat wait() until (PlayerCar.REAL.DRIFT.Position - Destination.Position).Magnitude <= 9
                    task.wait(.5)
                    game.ReplicatedStorage.CustomerMissions.CustomerMissionEnd:InvokeServer()
                end
            end)
        end
    end
    task.wait()
end
