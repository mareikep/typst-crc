import openpyxl
import yaml

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
    data = yaml.safe_load(wb["EXPORT"]["A5"].value)
    pis = yaml.safe_load(wb["EXPORT"]["B5"].value)
    projects = yaml.safe_load(wb["EXPORT"]["C5"].value)
    funding = yaml.safe_load(wb["EXPORT"]["D5"].value)
    aux = yaml.safe_load(wb["EXPORT"]["E5"].value)
except Exception as err:
    print(f"Unexpected {err=}, {type(err)=}")
finally:

    if data is not None:
        print(f"Writing general CRC metadata...")
        with open("metadata/crc-data.yaml", "w", encoding='utf-8') as f_data:
            yaml.dump(data, f_data, allow_unicode=True)
    else:
        print(f"There is no general CRC metadata available.")

    if pis is not None:
        print(f"Writing PI metadata...")
        with open("metadata/crc-persons.yaml", "w", encoding='utf-8') as f_pis:
            yaml.dump(pis, f_pis, allow_unicode=True)
    else:
        print(f"There is no PI metadata available.")

    if projects is not None:
        print(f"Writing project metadata...")
        with open("metadata/crc-projects.yaml", "w", encoding='utf-8') as f_projects:
            yaml.dump(projects, f_projects, allow_unicode=True)
    else:
        print(f"There is no project metadata available.")

    if funding is not None:
        print(f"Writing funding metadata...")
        with open("metadata/crc-funding.yaml", "w", encoding='utf-8') as f_funding:
            yaml.dump(funding, f_funding, allow_unicode=True)
    else:
        print(f"There is no funding metadata available.")

    if aux is not None:
        print(f"Writing aux metadata...")
        with open("metadata/crc-aux.yaml", "w", encoding='utf-8') as f_aux:
            yaml.dump(aux, f_aux, allow_unicode=True)
    else:
        print(f"There is no aux metadata available.")
