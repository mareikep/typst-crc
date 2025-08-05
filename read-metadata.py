import openpyxl

mytab = "\t"
myenter = "\n"
both = "\n  "
fname = "metadata/crc-metadata.xlsx"

data = None
projects = None
pis = None
funding = None
aux = None
try: 
    wb = openpyxl.load_workbook(fname, data_only=True)
    data = wb["EXPORT"]["A5"].value
    pis = wb["EXPORT"]["B5"].value
    projects = wb["EXPORT"]["C5"].value
    aux = wb["EXPORT"]["E5"].value
    fcells = wb["EXPORT"]["F5:V5"][0]
    fcells = [c.value for c in fcells]
    funding = f"funding: \n  {both.join(fcells)}"
except Exception as err:
    print(f"Unexpected {err=}, {type(err)=}")
finally:

    if data is not None:
        print(f"Writing general CRC metadata...")
        with open("metadata/crc-data.yaml", "w") as f_data:
            f_data.write(data)
    else:
        print(f"There is no general CRC metadata available.")

    if pis is not None:
        print(f"Writing PI metadata...")
        with open("metadata/crc-persons.yaml", "w") as f_pis:
            f_pis.write(pis)
    else:
        print(f"There is no PI metadata available.")

    if projects is not None:
        print(f"Writing project metadata...")
        with open("metadata/crc-projects.yaml", "w") as f_projects:
            f_projects.write(projects)
    else:
        print(f"There is no project metadata available.")

    if funding is not None:
        print(f"Writing funding metadata...")
        with open("metadata/crc-funding.yaml", "w") as f_funding:
            f_funding.write(funding)
    else:
        print(f"There is no funding metadata available.")

    if aux is not None:
        print(f"Writing aux metadata...")
        with open("metadata/crc-aux.yaml", "w") as f_aux:
            f_aux.write(aux)
    else:
        print(f"There is no aux metadata available.")
