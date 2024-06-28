

function Write-Task
{
    param
    (
        [Int]$SchedulingOperation = $null,
        [String]$PathStatementScheduling = "",
        [Object[][]]$TotalArrayScheduling = @()
    )

    function Write-TheSchedule
    {
        param
        (
            $SourceArrayTasking = @(),
            $DestArrayTasking = @(),
            [Int]$TheCountTasking,
            $FinalSourceDir = @(),
            $FinalDestDir = @(),
            $FinalSourceDirX = @(),
            $FinalDestDirX = @(),
            [Int]$FinalVerifyCountOne = $TheCountTasking,
            [Int]$FinalVerifyCountTwo = 0,
            [Int]$FinalVerifyCountOneX = $TheCountTasking,
            [Int]$FinalVerifyCountTwoX = 0,
            [Int]$DidAsk = 0,
            [Int]$UserChoice = $null,
            $AllReturnValues = @()
        )

        #Write-Host "Debug: Function: Write-TheSchedule | SourceArrayTasking: $SourceArrayTasking | DestArrayTasking: $DestArrayTasking | TheCountTasking: $TheCountTasking | FinalSourceDir: $FinalSourceDir | FinalDestDir: $FinalDestDir | FinalSourceDirX: $FinalSourceDirX | FinalDestDirX: $FinalDestDirX | FinalVerifyCountOne: $FinalVerifyCountOne | FinalVerifyCountTwo: $FinalVerifyCountTwo | FinalVerifyCountOneX: $FinalVerifyCountOneX | FinalVerifyCountTwoX: $FinalVerifyCountTwoX | DidAsk: $DidAsk | UserChoice: $UserChoice | AllReturnValues: $AllReturnValues" -ForegroundColor Green

        function Get-UserInputSchedulingOne
        {
            $UserChoiceXX = Read-Host "Choice"
            Write-Host

            if ($UserChoiceXX -eq "")
            {
                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                Write-Host

                return 0
            }

            [Bool]$IsItAnIntegerScheduling = [Int]::TryParse($UserChoiceXX, [ref]$null)

            if (-not $IsItAnIntegerScheduling)
            {
                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                Write-Host

                return 0
            }

            try
            {
                [Int]$UserChoiceX = [Int]$UserChoiceXX
            }
            catch [System.Management.Automation.RuntimeException]
            {
                if ($_.Exception.Message -like "*Input string was not in a correct format.*")
                {
                    Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                    Write-Host

                    return 0
                }
            }

            if (($UserChoiceX -eq 1) -or ($UserChoiceX -eq 2))
            {
                [Int]$ChosenUserChoice = $UserChoiceX

                return $ChosenUserChoice
            }
            elseif ($UserChoiceX -eq 0)
            {
                [Int]$LoopingLoop = 0

                Write-Host "You cannot go back from here. Choose 1 to restart." -ForegroundColor Yellow
                Write-Host

                while ($LoopingLoop -eq 0)
                {
                    Write-Host "Do you want to restart?"
                    Write-Host "1. Yes"
                    Write-Host "2. No"

                    $UserChoiceX = Read-Host "Choice"
                    Write-Host

                    if ($UserChoiceX -eq "")
                    {
                        Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                        Write-Host
                        continue
                    }

                    [Bool]$IntegerLooping = [Int]::TryParse($UserChoiceX, [ref]$null)

                    if (-not $IntegerLooping)
                    {
                        Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                        Write-Host
                        continue
                    }

                    try
                    {
                        [Int]$UserChoice = [Int]$UserChoiceX
                    }
                    catch [System.Management.Automation.RuntimeException]
                    {
                        if ($_.Exception.Message -like "*Input string was not in a correct format.*")
                        {
                            Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                            Write-Host
                            continue
                        }
                    }

                    if (($UserChoice -eq 1) -or ($UserChoice -eq 2))
                    {
                        [Int]$ChosenUserChoice = $UserChoice
                    }
                    elseif (($UserChoice -lt 1) -or ($UserChoice -gt 2))
                    {
                        Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                        Write-Host
                        continue
                    }
                    elseif ($UserChoice -eq 0)
                    {
                        Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                        Write-Host
                        continue
                    }
                    else
                    {
                        Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                        Write-Host
                        continue
                    }

                    if ($ChosenUserChoice -eq 2)
                    {
                        Write-Task -SchedulingOperation 1 -PathStatementScheduling $PathStatementScheduling -TotalArrayScheduling $TotalArrayScheduling
                    }

                    if ($ChosenUserChoice -eq 1)
                    {
                        Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                    }
                }
            }
            elseif (($UserChoiceX -lt 0) -or ($UserChoiceX -gt 2))
            {
                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                Write-Host

                return 0
            }
            else
            {
                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                Write-Host

                return 0
            }
        }

        if ($TheCountTasking -gt 1)
        {
            if ($DidAsk -eq 0)
            {
                [Int]$UserLoop = 0

                while ($UserLoop -eq 0)
                {
                    Write-Host "Would you like to schedule your $TheCountTasking backups for:"
                    Write-Host "1. All at the same day and time"
                    Write-Host "2. Different days and times"

                    $UserLoop = Get-UserInputSchedulingOne
                }

                $UserChoice = $UserLoop
                $DidAsk = 1
            }

            if ($UserChoice -eq 2)
            {
                if ($FinalVerifyCountTwo -lt $FinalVerifyCountOne)
                {
                    $FinalSourceDir += $SourceArrayTasking[$FinalVerifyCountTwo]
                    $FinalDestDir += $DestArrayTasking[$FinalVerifyCountTwo]

                    [Int]$Numbering = $FinalVerifyCountTwo + 1
                    Write-Host "Backup $Numbering. " -NoNewline
                    Write-Host "$($FinalSourceDir[$FinalVerifyCountTwo])" -ForegroundColor Yellow -NoNewline
                    Write-Host " to " -NoNewline
                    Write-Host "$($FinalDestDir[$FinalVerifyCountTwo])" -ForegroundColor Yellow

                    Get-SchedulingMenu -NumberX $Numbering -ControlNumber 1 -FlowControl 1 -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                }
                elseif ($FinalVerifyCountTwo -eq $FinalVerifyCountOne)
                {
                    if ($AllReturnValues.Count -eq $FinalVerifyCountOne)
                    {
                        Write-Host "$FinalVerifyCountOne backups have been sucessfully verified"
                        Write-Host "Thank you for using CaT Scheduler"
                        Write-Host
                        Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                    }
                    elseif ($AllReturnValues.Count -ne $FinalVerifyCountOne)
                    {
                        Write-Host "$FinalVerifyCountOne backups have not been sucessfully verified" -ForegroundColor Red
                        Write-Host
                        Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                    }
                    else
                    {
                        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(60)A Parent Function: Write-Task | Child Function: Write-TheSchedule | Variable UserChoice: $UserChoice (Should equal 2)"
                        Exit-CaTScheduler
                        Exit
                    }
                }
                else
                {
                    Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(60)B Parent Function: Write-Task | Child Function: Write-TheSchedule | Variable UserChoice: $UserChoice (Should equal 2)"
                    Exit-CaTScheduler
                    Exit
                }
            }
            elseif ($UserChoice -eq 1)
            {
                while ($FinalVerifyCountTwoX -lt $FinalVerifyCountOneX)
                {
                    $FinalSourceDirX += $SourceArrayTasking[$FinalVerifyCountTwoX]
                    $FinalDestDirX += $DestArrayTasking[$FinalVerifyCountTwoX]

                    [Int]$NumberingX = $FinalVerifyCountTwoX + 1
                    Write-Host "Backup $NumberingX. " -NoNewline
                    Write-Host "$($FinalSourceDirX[$FinalVerifyCountTwoX])" -ForegroundColor Yellow -NoNewline
                    Write-Host " to " -NoNewline
                    Write-Host "$($FinalDestDirX[$FinalVerifyCountTwoX])" -ForegroundColor Yellow

                    $FinalVerifyCountTwoX = $FinalVerifyCountTwoX + 1
                }

                Get-SchedulingMenu -NumberX $NumberingX -ControlNumber 0 -FlowControl 1 -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(61)A Parent Function: Write-Task | Child Function: Write-TheSchedule | Variable UserChoice: $UserChoice (Should equal 1)"
                Exit-CaTScheduler
                Exit
            }
        }
        elseif ($TheCountTasking -eq 1)
        {
            $UserChoice = 3

            $FinalSourceDir += $SourceArrayTasking[$FinalVerifyCountTwo]
            $FinalDestDir += $DestArrayTasking[$FinalVerifyCountTwo]

            [Int]$Numbering = $FinalVerifyCountTwo + 1
            Write-Host "Backup $Numbering. " -NoNewline
            Write-Host "$($FinalSourceDir[$FinalVerifyCountTwo])" -ForegroundColor Yellow -NoNewline
            Write-Host " to " -NoNewline
            Write-Host "$($FinalDestDir[$FinalVerifyCountTwo])" -ForegroundColor Yellow

            Get-SchedulingMenu -NumberX $Numbering -ControlNumber 1 -FlowControl 1 -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice
        }
        elseif ($TheCountTasking -eq 0)
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(62)A Parent Function: Write-Task | Child Function: Write-TheSchedule | Variable TheCountTasking: $TheCountTasking (Should equal 0), program fails with a value of zero"
            Exit-CaTScheduler
            Exit
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(62)B Parent Function: Write-Task | Child Function: Write-TheSchedule | Variable TheCountTasking: $TheCountTasking (Should equal 0)"
            Exit-CaTScheduler
            Exit
        }
    }

    function Get-SchedulingMenu
    {
        param
        (
            $NumberX = $null,
            $ControlNumber = $null,
            [Int]$GoBackNumber = 0,
            [String]$Often = "",
            [String]$Day = "",
            [Int]$Hour = $null,
            [Int]$Minute = $null,
            [String]$AmPm = "",
            $SchedulingVariables = @(),
            [Int]$FlowControl = $null,
            $SourceArrayTasking = @(),
            $DestArrayTasking = @(),
            [Int]$TheCountTasking,
            $FinalSourceDir = @(),
            $FinalDestDir = @(),
            $FinalSourceDirX = @(),
            $FinalDestDirX = @(),
            [Int]$FinalVerifyCountTwo = 0,
            [Int]$FinalVerifyCountOne = $TheCountTasking,
            [Int]$DidAsk = 0,
            [Int]$UserChoice = $null,
            $AllReturnValues = @()
        )

        #Write-Host "Debug: Function: Get-SchedulingMenu | Often: $Often | Day: $Day | Hour: $Hour | Minute: $Minute | Ampm: $AmPm | FlowControl: $FlowControl | GoBackNumber: $GoBackNumber | NumberX: $NumberX | ControlNumber: $ControlNumber | SchedulingVariables: $SchedulingVariables" -ForegroundColor Green
        #Write-Host "Debug: Function: Get-SchedulingMenu | SourceArrayTasking: $SourceArrayTasking | DestArrayTasking: $DestArrayTasking | TheCountTasking: $TheCountTasking | FinalSourceDir: $FinalSourceDir | FinalDestDir: $FinalDestDir | FinalSourceDirX: $FinalSourceDirX | FinalDestDirX: $FinalDestDirX | FinalVerifyCountTwo: $FinalVerifyCountTwo | FinalVerifyCountOne: $FinalVerifyCountOne | DidAsk: $DidAsk | UserChoice: $UserChoice | AllReturnValues: $AllReturnValues" -ForegroundColor Green

        function Get-UserInputSchedulingTwo
        {
            param
            (
                [Int]$NumberOfChoices = $null,
                [Int]$GoBackNumberX = $null,
                [Int]$NeedZero = 0
            )

            $UserChoiceXX = Read-Host "Choice"
            Write-Host

            if (($UserChoiceXX -eq "") -and (($NeedZero -eq 0) -or ($NeedZero -eq 1)))
            {
                if ($NeedZero -eq 1)
                {
                    Write-Host "Error: The input given was not valid. The options are 0 - $NumberOfChoices or 60 to go back" -ForegroundColor Red
                    Write-Host

                    return 60
                }
                else
                {
                    Write-Host "Error: The input given was not valid. The options are 1 - $NumberOfChoices or 0 to go back" -ForegroundColor Red
                    Write-Host

                    return 0
                }
            }

            [Bool]$IsItAnIntegerScheduling = [Int]::TryParse($UserChoiceXX, [ref]$null)

            if (-not $IsItAnIntegerScheduling)
            {
                if ($NeedZero -eq 1)
                {
                    Write-Host "Error: The input given was not valid. The options are 0 - $NumberOfChoices or 60 to go back" -ForegroundColor Red
                    Write-Host

                    return 60
                }
                else
                {
                    Write-Host "Error: The input given was not valid. The options are 1 - $NumberOfChoices or 0 to go back" -ForegroundColor Red
                    Write-Host

                    return 0
                }
            }

            try
            {
                [Int]$UserChoiceX = [Int]$UserChoiceXX
            }
            catch [System.Management.Automation.RuntimeException]
            {
                if ($_.Exception.Message -like "*Input string was not in a correct format.*")
                {
                    if ($NeedZero -eq 1)
                    {
                        Write-Host "Error: The input given was not valid. The options are 0 - $NumberOfChoices or 60 to go back" -ForegroundColor Red
                        Write-Host

                        return 60
                    }
                    else
                    {
                        Write-Host "Error: The input given was not valid. The options are 1 - $NumberOfChoices or 0 to go back" -ForegroundColor Red
                        Write-Host

                        return 0
                    }
                }
            }

            if ((($UserChoiceX -ge 1) -and ($UserChoiceX -le $NumberOfChoices)) -and ($NeedZero -eq 0))
            {
                [Int]$ChosenUserChoice = $UserChoiceX

                return $ChosenUserChoice
            }
            elseif ((($UserChoiceX -ge 0) -and ($UserChoiceX -le $NumberOfChoices)) -and ($NeedZero -eq 1))
            {
                [Int]$ChosenUserChoice = $UserChoiceX

                return $ChosenUserChoice
            }
            elseif (($UserChoiceX -eq 0) -and ($NeedZero -eq 0))
            {
                if ($GoBackNumberX -eq 1)
                {
                    if (($TheCountTasking -eq 1) -and ($AllReturnValues.Count -eq 0))
                    {
                        [Int]$LoopingLoop = 0

                        Write-Host "You cannot go back from here. Choose 1 to restart." -ForegroundColor Yellow
                        Write-Host

                        while ($LoopingLoop -eq 0)
                        {
                            Write-Host "Do you want to restart?"
                            Write-Host "1. Yes"
                            Write-Host "2. No"

                            $UserChoiceXXX = Read-Host "Choice"
                            Write-Host

                            if ($UserChoiceXXX -eq "")
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }

                            [Bool]$IntegerLooping = [Int]::TryParse($UserChoiceXXX, [ref]$null)

                            if (-not $IntegerLooping)
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }

                            try
                            {
                                [Int]$UserChoiceXX = [Int]$UserChoiceXXX
                            }
                            catch [System.Management.Automation.RuntimeException]
                            {
                                if ($_.Exception.Message -like "*Input string was not in a correct format.*")
                                {
                                    Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                    Write-Host
                                    continue
                                }
                            }

                            if (($UserChoiceXX -eq 1) -or ($UserChoiceXX -eq 2))
                            {
                                [Int]$ChosenUserChoice = $UserChoiceXX
                            }
                            elseif (($UserChoiceXX -lt 1) -or ($UserChoiceXX -gt 2))
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }
                            elseif ($UserChoiceXX -eq 0)
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }
                            else
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }

                            if ($ChosenUserChoice -eq 2)
                            {
                                Write-Task -SchedulingOperation 1 -PathStatementScheduling $PathStatementScheduling -TotalArrayScheduling $TotalArrayScheduling
                            }

                            if ($ChosenUserChoice -eq 1)
                            {
                                Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                            }
                        }
                    }
                    elseif (($TheCountTasking -gt 1) -and ($AllReturnValues.Count -eq 0))
                    {
                        Write-Task -SchedulingOperation 1 -PathStatementScheduling $PathStatementScheduling -TotalArrayScheduling $TotalArrayScheduling
                    }
                    elseif (($TheCountTasking -gt 1) -and ($AllReturnValues.Count -gt 0))
                    {
                        [Int]$LoopingLoop = 0

                        Write-Host "You cannot go back from here. Choose 2 to quit." -ForegroundColor Yellow
                        Write-Host "The backups you have already created will be preserved." -ForegroundColor Yellow
                        Write-Host

                        while ($LoopingLoop -eq 0)
                        {
                            Write-Host "Do you want to restart?"
                            Write-Host "1. Yes"
                            Write-Host "2. No"

                            $UserChoiceXXX = Read-Host "Choice"
                            Write-Host

                            if ($UserChoiceXXX -eq "")
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }

                            [Bool]$IntegerLooping = [Int]::TryParse($UserChoiceXXX, [ref]$null)

                            if (-not $IntegerLooping)
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }

                            try
                            {
                                [Int]$UserChoiceXX = [Int]$UserChoiceXXX
                            }
                            catch [System.Management.Automation.RuntimeException]
                            {
                                if ($_.Exception.Message -like "*Input string was not in a correct format.*")
                                {
                                    Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                    Write-Host
                                    continue
                                }
                            }

                            if (($UserChoiceXX -eq 1) -or ($UserChoiceXX -eq 2))
                            {
                                [Int]$ChosenUserChoice = $UserChoiceXX
                            }
                            elseif (($UserChoiceXX -lt 1) -or ($UserChoiceXX -gt 2))
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }
                            elseif ($UserChoiceXX -eq 0)
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }
                            else
                            {
                                Write-Host "Error: The input given was not valid. The options are 1 or 2" -ForegroundColor Red
                                Write-Host
                                continue
                            }

                            if ($ChosenUserChoice -eq 2)
                            {
                                Write-TheSchedule -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                            }

                            if ($ChosenUserChoice -eq 1)
                            {
                                Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                            }
                        }
                    }
                    else
                    {
                        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(63)A Parent Function: Write-Task | Child Function: Get-UserInputSchedulingTwo"
                        Exit-CaTScheduler
                        Exit
                    }
                }
                elseif ($GoBackNumberX -eq 2)
                {
                    Get-SchedulingMenu -NumberX $NumberX -ControlNumber $ControlNumber -FlowControl 0 -GoBackNumber 2 -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                }
                elseif ($GoBackNumberX -eq 3)
                {
                    if (($Day -eq "") -or ($Day -eq $null))
                    {
                        Get-SchedulingMenu -NumberX $NumberX -ControlNumber $ControlNumber -FlowControl 0 -GoBackNumber 2 -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                    }
                    elseif ((-not($Day -eq "")) -or (-not($Day -eq $null)))
                    {
                        Get-SchedulingMenu -NumberX $NumberX -ControlNumber $ControlNumber -FlowControl 0 -GoBackNumber 3 -Often $Often -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                    }
                    else
                    {
                        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(63)B Parent Function: Write-Task | Child Function: Get-UserInputSchedulingTwo"
                        Exit-CaTScheduler
                        Exit
                    }
                }
                elseif ($GoBackNumberX -eq 5)
                {
                    if (($Day -eq "") -or ($Day -eq $null))
                    {
                        Get-SchedulingMenu -NumberX $NumberX -ControlNumber $ControlNumber -FlowControl 0 -GoBackNumber 5 -Often $Often -Hour $Hour -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                    }
                    elseif ((-not($Day -eq "")) -or (-not($Day -eq $null)))
                    {
                        Get-SchedulingMenu -NumberX $NumberX -ControlNumber $ControlNumber -FlowControl 0 -GoBackNumber 5 -Often $Often -Day $Day -Hour $Hour -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                    }
                    else
                    {
                        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(63)C Parent Function: Write-Task | Child Function: Get-UserInputSchedulingTwo"
                        Exit-CaTScheduler
                        Exit
                    }
                }
                else
                {
                    Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(63)D Parent Function: Write-Task | Child Function: Get-UserInputSchedulingTwo"
                    Exit-CaTScheduler
                    Exit
                }
            }
            elseif (($UserChoiceX -eq 60) -and ($NeedZero -eq 1))
            {
                if ($GoBackNumberX -eq 4)
                {
                    if (($Day -eq "") -or ($Day -eq $null))
                    {
                        Get-SchedulingMenu -NumberX $NumberX -ControlNumber $ControlNumber -FlowControl 0 -GoBackNumber 4 -Often $Often -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                    }
                    elseif ((-not($Day -eq "")) -or (-not($Day -eq $null)))
                    {
                        Get-SchedulingMenu -NumberX $NumberX -ControlNumber $ControlNumber -FlowControl 0 -GoBackNumber 4 -Often $Often -Day $Day -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
                    }
                    else
                    {
                        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(63)E Parent Function: Write-Task | Child Function: Get-UserInputSchedulingTwo"
                        Exit-CaTScheduler
                        Exit
                    }
                }
                else
                {
                    Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(63)F Parent Function: Write-Task | Child Function: Get-UserInputSchedulingTwo"
                    Exit-CaTScheduler
                    Exit
                }
            }
            elseif ((($UserChoiceX -lt 0) -or ($UserChoiceX -gt $NumberOfChoices)) -and (($NeedZero -eq 0) -or ($NeedZero -eq 1)))
            {
                if ($NeedZero -eq 1)
                {
                    Write-Host "Error: The input given was not valid. The options are 0 - $NumberOfChoices or 60 to go back" -ForegroundColor Red
                    Write-Host

                    return 60
                }
                else
                {
                    Write-Host "Error: The input given was not valid. The options are 1 - $NumberOfChoices or 0 to go back" -ForegroundColor Red
                    Write-Host

                    return 0
                }
            }
            else
            {
                if ($NeedZero -eq 1)
                {
                    Write-Host "Error: The input given was not valid. The options are 0 - $NumberOfChoices or 60 to go back" -ForegroundColor Red
                    Write-Host

                    return 60
                }
                else
                {
                    Write-Host "Error: The input given was not valid. The options are 1 - $NumberOfChoices or 0 to go back" -ForegroundColor Red
                    Write-Host

                    return 0
                }
            }
        }

        function Get-SchedulingMenuOne
        {
            param
            (
                [Int]$Number,
                [Int]$ControlNum
            )

            if ($ControlNum -eq 1)
            {
                [Int]$LoopNumOne = 0

                while ($LoopNumOne -eq 0)
                {
                    Write-Host "How often do you want backup $Number to run?"
                    Write-Host "1. Daily"
                    Write-Host "2. Weekly"

                    $LoopNumOne = Get-UserInputSchedulingTwo -NumberOfChoices 2 -GoBackNumberX 1 -NeedZero 0
                }

                $UsrOftenChoice = $LoopNumOne
            }
            elseif ($ControlNum -eq 0)
            {
                [Int]$LoopNumOne = 0

                while ($LoopNumOne -eq 0)
                {
                    Write-Host "How often do you want your $Number backups to run?"
                    Write-Host "1. Daily"
                    Write-Host "2. Weekly"

                    $LoopNumOne = Get-UserInputSchedulingTwo -NumberOfChoices 2 -GoBackNumberX 1 -NeedZero 0
                }

                $UsrOftenChoice = $LoopNumOne
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(64)B Parent Function: Write-Task | Child Function: Get-SchedulingMenuOne | Variable ControlNum: $ControlNum (Should equal 0 or 1)"
                Exit-CaTScheduler
                Exit
            }

            if ($UsrOftenChoice -eq 1)
            {
                $OftenX = "Daily"
            }
            elseif ($UsrOftenChoice -eq 2)
            {
                $OftenX = "Weekly"
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(64)A Parent Function: Write-Task | Child Function: Get-SchedulingMenuOne | Variable UsrOftenChoice: $UsrOftenChoice (Shoudl equal 1 or 2)"
                Exit-CaTScheduler
                Exit
            }

            return $OftenX
        }

        function Get-SchedulingMenuTwo
        {
            [Int]$LoopNumOne = 0

            while ($LoopNumOne -eq 0)
            {
                Write-Host "Which day of the week?"
                Write-Host "1. Sunday"
                Write-Host "2. Monday"
                Write-Host "3. Tuesday"
                Write-Host "4. Wednesday"
                Write-Host "5. Thursday"
                Write-Host "6. Friday"
                Write-Host "7. Saturday"

                $LoopNumOne = Get-UserInputSchedulingTwo -NumberOfChoices 7 -GoBackNumberX 2 -NeedZero 0
            }

            $DayOfWeek = $LoopNumOne

            if ($DayOfWeek -eq 1)
            {
                $DayX = "Sunday"
            }
            elseif ($DayOfWeek -eq 2)
            {
                $DayX = "Monday"
            }
            elseif ($DayOfWeek -eq 3)
            {
                $DayX = "Tuesday"
            }
            elseif ($DayOfWeek -eq 4)
            {
                $DayX = "Wednesday"
            }
            elseif ($DayOfWeek -eq 5)
            {
                $DayX = "Thursday"
            }
            elseif ($DayOfWeek -eq 6)
            {
                $DayX = "Friday"
            }
            elseif ($DayOfWeek -eq 7)
            {
                $DayX = "Saturday"
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(65)A Parent Function: Write-Task | Child Function: Get-SchedulingMenuTwo | Variable DayOfWeek: $DayOfWeek (Shoudl equal 1 - 7)"
                Exit-CaTScheduler
                Exit
            }

            return $DayX
        }

        function Get-SchedulingMenuThree
        {
            [Int]$LoopNumOne = 0

            while ($LoopNumOne -eq 0)
            {
                Write-Host "XX" -NoNewline -ForegroundColor Yellow
                Write-Host ":XX AM/PM"
                Write-Host "01 02 03 04 05 06 07 08 09 10 11 12"
                Write-Host "Type in the hour you want the backup to happen"

                $LoopNumOne = Get-UserInputSchedulingTwo -NumberOfChoices 12 -GoBackNumberX 3 -NeedZero 0
            }

            $UsrHourChoice = $LoopNumOne

            if (($UsrHourChoice -ge 1) -and ($UsrHourChoice -le 12))
            {
                $HourX = $UsrHourChoice
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(66)A Parent Function: Write-Task | Child Function: Get-SchedulingMenuThree | Variable UsrHourChoice: $UsrHourChoice (Shoudl equal 1 - 12)"
                Exit-CaTScheduler
                Exit
            }

            return $HourX
        }

        function Get-SchedulingMenuFour
        {
            [Int]$LoopNumOne = 60

            while ($LoopNumOne -eq 60)
            {
                Write-Host "XX:" -NoNewline
                Write-Host "XX" -NoNewline -ForegroundColor Yellow
                Write-Host " AM/PM"
                Write-Host "00 - 59"
                Write-Host "Type in the minute you want the backup to happen"  -NoNewline
                Write-Host "    (60 is to go back)" -ForegroundColor Yellow

                $LoopNumOne = Get-UserInputSchedulingTwo -NumberOfChoices 59 -GoBackNumberX 4 -NeedZero 1
            }

            $UsrMinuteChoice = $LoopNumOne

            if (($UsrMinuteChoice -ge 0) -and ($UsrMinuteChoice -le 59))
            {
                $MinuteX = $UsrMinuteChoice
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(67)A Parent Function: Write-Task | Child Function: Get-SchedulingMenuFour | Variable UsrMinuteChoice: $UsrMinuteChoice (Shoudl equal 0 - 59)"
                Exit-CaTScheduler
                Exit
            }

            return $MinuteX
        }

        function Get-SchedulingMenuFive
        {
            [Int]$LoopNumOne = 0

            while ($LoopNumOne -eq 0)
            {
                Write-Host "XX:XX" -NoNewline
                Write-Host " AM/PM" -ForegroundColor Yellow
                Write-Host "AM or PM?"
                Write-Host "1. AM"
                Write-Host "2. PM"

                $LoopNumOne = Get-UserInputSchedulingTwo -NumberOfChoices 2 -GoBackNumberX 5 -NeedZero 0
            }

            $UsrAmpmChoice = $LoopNumOne

            if ($UsrAmpmChoice -eq 1)
            {
                $AmPmX = "AM"
            }
            elseif ($UsrAmpmChoice -eq 2)
            {
                $AmPmX = "PM"
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(68)A Parent Function: Write-Task | Child Function: Get-SchedulingMenuFive | Variable UsrAmpmChoice: $UsrAmpmChoice (Shoudl equal 1 or 2)"
                Exit-CaTScheduler
                Exit
            }

            return $AmPmX
        }

        if (($FlowControl -eq 1) -or ($GoBackNumber -eq 2))
        {
            $Often = Get-SchedulingMenuOne -Number $NumberX -ControlNum $ControlNumber

            if ($Often -eq "Weekly")
            {
                $FlowControl = 2
            }
            elseif ($Often -eq "Daily")
            {
                $FlowControl = 3
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(69)A Parent Function: Write-Task | Variable Often: $Often (Shoudl equal Weekly or Daily)"
                Exit-CaTScheduler
                Exit
            }
        }

        if (($FlowControl -eq 2) -or ($GoBackNumber -eq 3))
        {
            $Day = Get-SchedulingMenuTwo

            $FlowControl = 3
        }

        if (($FlowControl -eq 3) -or ($GoBackNumber -eq 4))
        {
            $Hour = Get-SchedulingMenuThree

            $FlowControl = 4
        }

        if (($FlowControl -eq 4) -or ($GoBackNumber -eq 5))
        {
            $Minute = Get-SchedulingMenuFour

            $FlowControl = 5
        }

        if ($FlowControl -eq 5)
        {
            $AmPm = Get-SchedulingMenuFive

            $FlowControl = 6
        }

        if ($FlowControl -eq 6)
        {

            if (($Day -eq "") -or ($Day -eq $null))
            {
                $SchedulingVariablesX = @($Often, $Hour, $Minute, $AmPm)

                $FlowControl = 7
            }
            elseif ((-not($Day -eq "")) -or (-not($Day -eq $null)))
            {
                $SchedulingVariablesX = @($Often, $Day, $Hour, $Minute, $AmPm)

                $FlowControl = 7
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(70)A Parent Function: Write-Task | Variable FlowControl: $FlowControl  (Shoudl equal 6)"
                Exit-CaTScheduler
                Exit
            }
        }

        if ($FlowControl -eq 7)
        {
            $NumberX = $null,
            $ControlNumber = $null
            [Int]$GoBackNumber = 0
            [String]$Often = ""
            [String]$Day = ""
            [Int]$Hour = $null
            [Int]$Minute = $null
            [String]$AmPm = ""
            $SchedulingVariables = @()
            [Int]$FlowControl = $null

            Get-SchedulingMenu -FlowControl 8 -SchedulingVariables $SchedulingVariablesX -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
        }

        if ($FlowControl -eq 8)
        {
            $SchedulingVariablesXX = $SchedulingVariables

            if (($UserChoice -eq 1) -or ($UserChoice -eq 3))
            {
                while ($FinalVerifyCountTwo -lt $FinalVerifyCountOne)
                {
                    $FinalSourceDir += $SourceArrayTasking[$FinalVerifyCountTwo]
                    $FinalDestDir += $DestArrayTasking[$FinalVerifyCountTwo]

                    [Bool]$TaskCreationReturnValue = Format-TheScheduledTask -SourceDir $FinalSourceDir[$FinalVerifyCountTwo] -DestinationDir $FinalDestDir[$FinalVerifyCountTwo] -SchedulingVariables $SchedulingVariablesXX

                    [Int]$TaskCreationNumbering = $FinalVerifyCountTwo + 1

                    [String]$SourceX = $FinalSourceDir[$FinalVerifyCountTwo]
                    [String]$DestX = $FinalDestDir[$FinalVerifyCountTwo]

                    if (($TaskCreationReturnValue -eq $false) -or (-not($TaskCreationReturnValue -eq $true)))
                    {
                        Write-Host
                        Write-Host "Backup $TaskCreationNumbering was not sucessfully verified" -ForegroundColor Red
                        Write-Host "Source: $SourceX" -ForegroundColor Red
                        Write-Host "Destination: $DestX" -ForegroundColor Red
                        Write-Host
                    }
                    elseif ($TaskCreationReturnValue -eq $true)
                    {
                        Write-Host
                        Write-Host "Backup $TaskCreationNumbering was sucessfully verified"
                        Write-Host "Source: $SourceX"
                        Write-Host "Destination: $DestX"
                        Write-Host
                    }
                    else
                    {
                        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(70)A Parent Function: Write-Task | Variable FlowControl: $FlowControl  (Shoudl equal 8)"
                        Exit-CaTScheduler
                        Exit
                    }

                    $AllReturnValues += $TaskCreationReturnValue

                    $FinalVerifyCountTwo = $FinalVerifyCountTwo + 1
                }

                if ($AllReturnValues.Count -eq $FinalVerifyCountOne)
                {
                    if ($UserChoice -eq 1)
                    {
                        Write-Host "$FinalVerifyCountOne backups have been sucessfully verified"
                        Write-Host "Thank you for using CaT Scheduler"
                        Write-Host
                        Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                    }
                    elseif ($UserChoice -eq 3)
                    {
                        Write-Host "$FinalVerifyCountOne backup was sucessfully verified"
                        Write-Host "Thank you for using CaT Scheduler"
                        Write-Host
                        Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                    }
                    else
                    {
                        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(70)B Parent Function: Write-Task | Variable FlowControl: $FlowControl  (Shoudl equal 8)"
                        Exit-CaTScheduler
                        Exit
                    }
                }
                elseif ($AllReturnValues.Count -ne $FinalVerifyCountOne)
                {
                    Write-Host "$FinalVerifyCountOne backups have not been sucessfully verified" -ForegroundColor Red
                    Write-Host
                    Start-CaTScheduler -PathStatementStartup $PathStatementScheduling -Start 1
                }
                else
                {
                    Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(70)C Parent Function: Write-Task | Variable FlowControl: $FlowControl  (Shoudl equal 8)"
                    Exit-CaTScheduler
                    Exit
                }
            }
            elseif ($UserChoice -eq 2)
            {
                [Bool]$TaskCreationReturnValue = Format-TheScheduledTask -SourceDir $FinalSourceDir[$FinalVerifyCountTwo] -DestinationDir $FinalDestDir[$FinalVerifyCountTwo] -SchedulingVariables $SchedulingVariablesXX

                [Int]$TaskCreationNumbering = $FinalVerifyCountTwo + 1

                [String]$SourceX = $FinalSourceDir[$FinalVerifyCountTwo]
                [String]$DestX = $FinalDestDir[$FinalVerifyCountTwo]

                if (($TaskCreationReturnValue -eq $false) -or (-not($TaskCreationReturnValue -eq $true)))
                {
                    Write-Host
                    Write-Host "Backup $TaskCreationNumbering was not sucessfully verified" -ForegroundColor Red
                    Write-Host "Source: $SourceX" -ForegroundColor Red
                    Write-Host "Destination: $DestX" -ForegroundColor Red
                    Write-Host
                }
                elseif ($TaskCreationReturnValue -eq $true)
                {
                    Write-Host
                    Write-Host "Backup $TaskCreationNumbering was sucessfully verified"
                    Write-Host "Source: $SourceX"
                    Write-Host "Destination: $DestX"
                    Write-Host
                }
                else
                {
                    Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(70)D Parent Function: Write-Task | Variable FlowControl: $FlowControl  (Shoudl equal 8)"
                    Exit-CaTScheduler
                    Exit
                }

                $AllReturnValues += $TaskCreationReturnValue

                $FinalVerifyCountTwo = $FinalVerifyCountTwo + 1

                Write-TheSchedule -SourceArrayTasking $SourceArrayTasking -DestArrayTasking $DestArrayTasking -TheCountTasking $TheCountTasking -FinalSourceDir $FinalSourceDir -FinalDestDir $FinalDestDir -FinalVerifyCountTwo $FinalVerifyCountTwo -FinalVerifyCountOne $FinalVerifyCountOne -DidAsk $DidAsk -UserChoice $UserChoice -AllReturnValues $AllReturnValues
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(70)E Parent Function: Write-Task | Variable FlowControl: $FlowControl  (Shoudl equal 8)"
                Exit-CaTScheduler
                Exit
            }
        }
    }

    function Format-TheScheduledTask
    {
        param
        (
            [String]$SourceDir,
            [String]$DestinationDir,
            $SchedulingVariables = @()
        )

        function Get-TaskNumber
        {
            [String]$FilePath = "$PathStatementScheduling\ConfigurationFiles\TaskNumber.txt"
            $Content = Get-Content -Path $FilePath
            [Int]$TaskNumber = [Int]$Content

            return $TaskNumber
        }

        [Int]$ScheduledTaskNumber = Get-TaskNumber

        [Int]$ScheduledTaskNumberX = $ScheduledTaskNumber + 1

        if ($SchedulingVariables.Count -eq 5)
        {
            [String]$OftenX = $SchedulingVariables[0]
            [String]$DayX = $SchedulingVariables[1]
            [String]$HourX = $SchedulingVariables[2]
            [String]$MinuteX = $SchedulingVariables[3]
            [String]$AmpmX = $SchedulingVariables[4]
        }
        elseif ($SchedulingVariables.Count -eq 4)
        {
            [String]$OftenX = $SchedulingVariables[0]
            [String]$HourX = $SchedulingVariables[1]
            [String]$MinuteX = $SchedulingVariables[2]
            [String]$AmpmX = $SchedulingVariables[3]
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(71)A Parent Function: Write-Task | Child Function: Format-TheScheduledTask | Variable SchedulingVariables Count should equal 4 or 5"
            Exit-CaTScheduler
            Exit
        }

        if ($MinuteX.Length -eq 1)
        {
            [String]$TimeX = "$($HourX):0$($MinuteX)$($AmpmX)"
        }
        elseif ($MinuteX.Length -eq 2)
        {
            [String]$TimeX = "$($HourX):$($MinuteX)$($AmpmX)"
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(71)B Parent Function: Write-Task | Child Function: Format-TheScheduledTask | Variable MinuteX length should equal 1 or 2"
            Exit-CaTScheduler
            Exit
        }

        [String]$Taskname = "CaT_Scheduler_$ScheduledTaskNumberX"

        if ($OftenX -eq "Daily")
        {
            $Trigger = New-ScheduledTaskTrigger -Daily -At $TimeX

            [Int]$EndMsg = 1
        }
        elseif ($OftenX -eq "Weekly")
        {
            $Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $DayX -At $TimeX

            [Int]$EndMsg = 2
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(71)C Parent Function: Write-Task | Child Function: Format-TheScheduledTask | Variable OftenX: $OftenX (Should equal Daily or Weekly)"
            Exit-CaTScheduler
            Exit
        }

        [String]$WrapperScript = "$PathStatementScheduling\WrapperScript.ps1"

        [String]$Arguments = "-NoProfile -WindowStyle Hidden -File `"$WrapperScript`" -SourceDir `"$SourceDir`" -DestDir `"$DestinationDir`""

        $Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument $Arguments
        $Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

        $NewTaskAction = Register-ScheduledTask -TaskName $Taskname -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Description "Task created by CaT Scheduler."

        [String]$FilePath = "$PathStatementScheduling\ConfigurationFiles\TaskNumber.txt"
        $NewItemTaskNumber = New-Item -Path $FilePath -ItemType File -Value $ScheduledTaskNumberX -Force

        if ($EndMsg -eq 1)
        {
            Write-Host "$Taskname has been scheduled!" -ForegroundColor Yellow
            Write-Host "$Taskname will automatically backup $SourceDir to $DestinationDir" -ForegroundColor Yellow
            Write-Host "The backup will take place daily at $TimeX" -ForegroundColor Yellow
            Write-Host "You can change or delete this backup by going to the main menu!" -ForegroundColor Yellow
        }
        elseif ($EndMsg -eq 2)
        {
            Write-Host "$Taskname has been scheduled!" -ForegroundColor Yellow
            Write-Host "$Taskname will automatically backup $SourceDir to $DestinationDir" -ForegroundColor Yellow
            Write-Host "The backup will take place weekly on $DayX at $TimeX" -ForegroundColor Yellow
            Write-Host "You can change or delete this backup by going to the main menu!" -ForegroundColor Yellow
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(71)D Parent Function: Write-Task | Child Function: Format-TheScheduledTask | Variable EndMsg: $EndMsg (Should equal 1 or 2)"
            Exit-CaTScheduler
            Exit
        }

        if ($SchedulingVariables.Count -eq 5)
        {
            $AllVariables = @($SourceDir, $DestinationDir, $SchedulingVariables, $ScheduledTaskNumber, $ScheduledTaskNumberX, $OftenX, $DayX, $HourX, $MinuteX, $AmpmX, $TimeX, $Taskname, $Trigger, $EndMsg, $WrapperScript, $Arguments, $Action, $Principal, $Settings, $NewTaskAction, $FilePath, $NewItemTaskNumber)

            if ($AllVariables -contains $null)
            {
                [Bool]$DoesNotHaveNull = $false
            }
            elseif (-not($AllVariables -contains $null))
            {
                [Bool]$DoesNotHaveNull = $true
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(72)A Parent Function: Write-Task | Child Function: Format-TheScheduledTask"
                Exit-CaTScheduler
                Exit
            }
        }
        elseif ($SchedulingVariables.Count -eq 4)
        {
            $AllVariables = @($SourceDir, $DestinationDir, $SchedulingVariables, $ScheduledTaskNumber, $ScheduledTaskNumberX, $OftenX, $HourX, $MinuteX, $AmpmX, $TimeX, $Taskname, $Trigger, $EndMsg, $WrapperScript, $Arguments, $Action, $Principal, $Settings, $NewTaskAction, $FilePath, $NewItemTaskNumber)

            if ($AllVariables -contains $null)
            {
                [Bool]$DoesNotHaveNull = $false
            }
            elseif (-not($AllVariables -contains $null))
            {
                [Bool]$DoesNotHaveNull = $true
            }
            else
            {
                Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(72)B Parent Function: Write-Task | Child Function: Format-TheScheduledTask"
                Exit-CaTScheduler
                Exit
            }
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(72)C Parent Function: Write-Task | Child Function: Format-TheScheduledTask | Variable SchedulingVariables Count should equal 4 or 5"
            Exit-CaTScheduler
            Exit
        }

        if ($DoesNotHaveNull -eq $true)
        {
            [Bool]$ReturnTrue = $true

            return $ReturnTrue
        }
        elseif ($DoesNotHaveNull -eq $false)
        {
            [Bool]$ReturnFalse = $false

            return $ReturnFalse
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(73)A Parent Function: Write-Task | Child Function: Format-TheScheduledTask | Variable DoesNotHaveNull: $DoesNotHaveNull (Should equal true or false)"
            Exit-CaTScheduler
            Exit
        }
    }

    if ($SchedulingOperation -eq 1)
    {
        $SourceArrayScheduling = $TotalArrayScheduling[0]
        $DestinationArrayScheduling = $TotalArrayScheduling[1]

        [Int]$SourceCountScheduling = $SourceArrayScheduling.Count
        [Int]$DestCountScheduling = $DestinationArrayScheduling.Count

        if ($SourceCountScheduling -ne $DestCountScheduling)
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(60)A. Parent Function: Write-Task | Variable SchedulingOperation: $SchedulingOperation (Should equal 1) | Variable SourceCountScheduling: $SourceCountScheduling is not equal to DestCountScheduling: $DestCountScheduling"
            Exit-CaTScheduler
            Exit
        }
        elseif ($SourceCountScheduling -eq $DestCountScheduling)
        {
            [Int]$FinalCountScheduling = $SourceCountScheduling
        }
        else
        {
            Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(60)B. Parent Function: Write-Task | Variable SchedulingOperation: $SchedulingOperation (Should equal 1)"
            Exit-CaTScheduler
            Exit
        }

        Write-TheSchedule -SourceArrayTasking $SourceArrayScheduling -DestArrayTasking $DestinationArrayScheduling -TheCountTasking $FinalCountScheduling
    }
    else
    {
        Invoke-ReadWrite -OperationChoice 1 -PathStatementReadWrite $PathStatementScheduling -LogType 3 -Message "(57)A. Parent Function: Start-Backup | Variable BackupOperation: $BackupOperation (Should not equal 1)"
        Exit-CaTScheduler
        Exit
    }
}

    Export-ModuleMember -Function Write-Task
