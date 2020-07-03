import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="collective-client",
    version="0.1.0",
    author="Connor Burns",
    author_email="ctrekker4@gmail.com",
    description="A client for the collective server",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/ctrekker/collective.git",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)