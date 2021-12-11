chunkify.js
=============
Function was added to split text (as strings) into smaller chunks of no more than characters specified by the end user. Function was subsequently exported. (_Recursive Implementation_)

test
=========
Directory with relevant testing environment (chunkify_test.js) and python script to generate user inputs for testing (gen_chunkify_test_inputs.py)



## Testing with MochaJS

### Setup

This guide is meant for the WebStorm IDE by JetBrains. For other IDEs please refer to the respective setup guides.

(Alternatively, refer to [Mocha - the fun, simple, flexible JavaScript test framework (mochajs.org)](https://mochajs.org/#installation))

1. Run `npm i --g mocha` in your terminal to install Mocha.
2. Navigate to `Run > Edit Configurations` from the menu bar to open the `Run/Debug Configurations` window.
3. Click on the `+` icon on the top left and select Mocha. (Don't see Mocha as an Option? You'll need to add the Node.js Plug-in to WebStorm first)
4. Name the configuration any relevant name (e.g. `ChunkifyTestingSuite`).
5. Select the Node.js interpreter used by your project (The default interpreter should be the one used by the Project - this is sufficient).
6. Ensure that the Working directory is the Project directory, and the Mocha package refers to the installed Mocha package.
7. User interface should be set to `bdd`.
8. For the Test directory, choose the folder containing test suites (e.g. `helpers/test`), and select the `All in directory` option above it.
9. Click ok to complete Configuration setup.
10. Test cases written in the Mocha framework within the test directory can now be run by running the configuration!

