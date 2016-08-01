#########################################################################
#                        Add shared_assemblies                          #
#########################################################################

# Mahapps Library
[System.Reflection.Assembly]::LoadFrom('Assembly\MahApps.Metro.dll')       | out-null
[System.Reflection.Assembly]::LoadFrom('Assembly\System.Windows.Interactivity.dll') | out-null

#########################################################################
#                        Load Main Panel                                #
#########################################################################

# return the directory of source files
$Script:pathPanel= split-path -parent $MyInvocation.MyCommand.Definition

# function to load the xaml
function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow = LoadXaml($pathPanel+"\window.metro.xaml")  #MahApps
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form = [Windows.Markup.XamlReader]::Load($reader)

#########################################################################
#   Linking PS to xaml                                                  #
#########################################################################

$MyTextBox     = $Form.FindName("MyTextBox")

$MyButton      = $Form.FindName("MyButton")

$RadioButtonArea = $Form.FindName("RadioButtonArea")
$MyRadio1        = $Form.FindName("MyRadio1")
$MyRadio2        = $Form.FindName("MyRadio2")
$MyRadio3        = $Form.FindName("MyRadio3")


$CheckBoxArea  = $Form.FindName("CheckBoxArea")
$MyCheckBox1   = $Form.FindName("MyCheckBox1")
$MyCheckBox2   = $Form.FindName("MyCheckBox2")

$MyComboBox     = $Form.FindName("MyComboBox")
$MyComboItem1   = $Form.FindName("MyComboItem1")
$MyComboItem2   = $Form.FindName("MyComboItem2")
$MyComboItem3   = $Form.FindName("MyComboItem3")
$MyComboItem4   = $Form.FindName("MyComboItem4")

$MyImage       = $Form.FindName("MyImage")


#########################################################################
# Manage event                                                          #
#########################################################################


#******************** Button *****************************
$MyButton.Add_Click({
    $Form.close()
    Write-Host "You clicked MyButton"
})


#******************* ComboBox *****************************

$MyComboBox.add_SelectionChanged({
    $SelectedItem = $MyComboBox.SelectedItem.Name
     switch ($SelectedItem){            
                "MyComboItem1"    { Write-Host "This is the combobox Item 1"} 
                "MyComboItem2"    { Write-Host "This is the combobox Item 2"} 
                "MyComboItem3"    { Write-Host "This is the combobox Item 3"}
                "MyComboItem4"    { Write-Host "This is the combobox Item 4"} 
                default { Write-Host "Ooops!"}
   } 

})


#******************* TextBox ******************************

$MyTextBox.add_TextChanged({ 
    Write-Host $MyTextBox.Text
})

#******************* radiobutton **************************

[System.Windows.RoutedEventHandler]$ChoosedRadioHandler = {

    Write-Host $_.source.GroupName 
    Write-Host $_.source.Content
}
$RadioButtonArea.AddHandler([System.Windows.Controls.RadioButton]::CheckedEvent, $ChoosedRadioHandler)


#***************** Image *********************************

$MyImage.Add_MouseEnter({ $Form.Cursor = [System.Windows.Input.Cursors]::Hand  })
$MyImage.Add_MouseLeave({ $Form.Cursor = [System.Windows.Input.Cursors]::Arrow })
$MyImage.Add_MouseLeftButtonDown({
    Write-Host "you clicked on the image"
})

#########################################################################
#                        Show Dialog                                    #
#########################################################################

$Form.ShowDialog() | Out-Null