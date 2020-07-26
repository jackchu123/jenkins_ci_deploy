# -*- coding:utf-8 _*-
# appops cloud_v2.1 2020/05/13 version 1.0
import requests,json
from requests_toolbelt.multipart.encoder import MultipartEncoder
from configparser import ConfigParser
import urllib3
import time
urllib3.disable_warnings()
t =time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))

class Api_test():

    def __init__(self, s):
        self.s = s
        self.s.verify = False
        self.url = "https://fcloud.qccvas.com/gateway-nginx"
        self.headers = {"TenantId": "suntech","Content-Type": "application/json"}

    def login(self,username,password):
        # data = json.dumps({"userName":username,"password": password,"tenantId":"manager"})
        data = json.dumps({"userName":username,"password": password})
        # r = self.s.post(url=self.url+"/QCCVAS-BIZ-USER/login/pc",data=data,headers=self.headers)
        r = self.s.post(url=self.url+"/QCCVAS-BIZ-MANAGER/login",data=data,headers=self.headers)
        qwe = r.json()
        token = qwe["data"]["token"]
        h1 = {"Authorization": token}
        self.s.headers.update(h1)
        return token


    def logout(self):
        r = self.s.delete(url=self.url+"/QCCVAS-BIZ-USER/logout",headers=self.headers)
        print(r.text)

    def qcc_001(self):
        r1 = self.s.get(url=self.url+"/QCCVAS-BIZ-USER/vidCid/getVidCid",headers=self.headers)
        r2 = self.s.get(url=self.url+"/QCCVAS-BIZ-GOODS/codesCategory/selectCodeScope",headers=self.headers)
        r3 = self.s.get(url=self.url+"/QCCVAS-BIZ-GOODS/codesCategory/selectPage?order=createDate&asc=false&keyString=",headers=self.headers)
        r4 = self.s.get(url=self.url+"/QCCVAS-BIZ-GOODS/codes/selectPage?current=1&rows=20&order=createDate&asc=false&codesCategoryId=6684979055443312640",headers=self.headers)
        # print(r1.text,"\n",r2.text,"\n",r3.text,"\n",r4.text,"\n")
        print(r1.text)

    def qcc_002(self, app_version, app_id, app_name):
        files = {"file": (app_name,open('./test_files/zipfile/' + app_name, 'rb'),"application/zip")}
        m = MultipartEncoder(
                fields=[
                    ("appVersion", app_version),
                    ("updateDesc", "version update"),
                    ("appPackageId", app_id),
                    ("pubTime", t),
                    ("forceUpdate", "0"),
                    ("online", "1"),
                    ("pubType", "0"),
                    ("packageType", "0"),
                    ("developer","开发"),
                    ("file", (app_name, open('./test_files/zipfile/' + app_name, 'rb')))
                ]
        )
        r = self.s.post(url=self.url+"/QCCVAS-BIZ-MANAGER/appVersionInfo/publishAppVersion",data=m, headers={"Content-Type":m.content_type})
        print(r.text)

    def test_read(self, zipname):
        try:
            cfg = ConfigParser()
            cfg.read('./test_files/app_version.ini')
            cfg.sections()
            version_num = cfg.get(zipname,'app_version')
            #old_num = int(version_num[-1:]) + 1
            new_num=str(int(version_num.split('.', 2)[2])+1)
            old_num = version_num[:4]
            version_num = str(old_num)+str(new_num)
            cfg.set(zipname,'app_version',version_num)
            iniset = open(r'./test_files/app_version.ini', 'w')
            cfg.write(iniset)
            # insert data
            app_version = cfg.get(zipname,'app_version')
            #print(cfg.get(zipname,'app_version'))
            app_id = cfg.get(zipname,'app_id')
            app_name = cfg.get(zipname,'app_name')
            self.qcc_002(app_version,app_id,app_name)
            iniset.close
        except Exception as e:
            raise e

    def app_update(self):
        try:
            f = open('./test_files/appupdate_list.txt')
            lines = f.read().splitlines()
            for line in lines:
                self.test_read(line)
            f.close
        except Exception as e:
            raise e

if __name__ == '__main__':
    s = requests.Session()
    a = Api_test(s)
    a.login(username="qccvasadmin",password=123456)
    # print(s.headers)
    #a.qcc_002()
    a.app_update()

