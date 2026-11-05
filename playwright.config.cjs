const {defineConfig}=require('@playwright/test');
module.exports=defineConfig({testDir:'tests/browser',workers:1,timeout:120000,use:{baseURL:'http://127.0.0.1:8123',channel:'msedge',headless:true},webServer:{command:'py -m backend.server',url:'http://127.0.0.1:8123/api/health',reuseExistingServer:false,env:{PORT:'8123',DATABASE_PATH:'data/accessibility-test.sqlite3'}},reporter:'list'});
