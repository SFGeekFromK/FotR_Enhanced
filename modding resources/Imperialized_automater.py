import xml.etree.ElementTree as ET

List = [x for x in input("Enter Heroes to make Decolorized variant of(please separate with space):").split()]

if len(List)==0 :
    print("No hero entry detected.")
    exit()    

xml_name=str(input("Enter xml name to be used(type without .xml): "))

root = ET.Element(xml_name)
for entry in List:
    Hero_bundle=entry.split(",")
    Republic_Name=Hero_bundle[0]
    Imperial_Name=f"{Republic_Name}_Imp"
    Retire_Dummy_Name=Hero_bundle[1]

    unique_Unit = ET.SubElement(root, "UniqueUnit", Name=Imperial_Name)

    ET.SubElement(unique_Unit, "Variant_Of_Existing_Type").text = Republic_Name
    ET.SubElement(unique_Unit, "No_Colorization_Color").text = "255, 255, 255, 255"

    dummy_Structure = ET.SubElement(root, "DummyStructure", Name=f"{Retire_Dummy_Name}_Imp")
    ET.SubElement(dummy_Structure, "Variant_Of_Existing_Type").text = Retire_Dummy_Name
    ET.SubElement(dummy_Structure, "Required_Orbiting_Units").text = Imperial_Name

tree = ET.ElementTree(root)
tree.write(xml_name+".xml")
