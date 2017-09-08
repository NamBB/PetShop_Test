# User Guide
## Preparation

** Install robot framework with python **

```python
  pip install robotframework```

** Install robot framework Selenium library **
```python
  pip install robotframework-selenium2library```

** Install Selenium WebDriver **

In this test, I use Chrome as WebDriver. Therefore you need to:
1. Install Chrome as Browser in the default location
2. Download ChromeDriver for your environment [ChromeDriver Download](https://sites.google.com/a/chromium.org/chromedriver/downloads)
3. Include the ChromeDriver location in your PATH environment variable


## Cloning the Tests
Clone the test from Git Hub
```html
https://github.com/NamBB/PetShop_Test.git```


## Execution
```python
robot test/valid_test.robot```
