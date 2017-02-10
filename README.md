# merge_junit_report plugin

[![Gem](https://badge.fury.io/rb/fastlane-plugin-merge_junit_report.svg)](https://badge.fury.io/rb/fastlane-plugin-merge_junit_report)
[![Build Status](https://travis-ci.org/dyang/merge_junit_report.svg?branch=master)](https://travis-ci.org/dyang/merge_junit_report)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-merge_junit_report`, add it to your project by running:

```bash
fastlane add_plugin merge_junit_report
```

## About merge_junit_report

Merge_junit_report is a [Fastlane](https://fastlane.tools/) plugin that merges multiple junit reports into one single report. It's primarily designed to be used in conjunction with another Fastlane plugin [fastlane-plugin-setup_fragile_tests_for_rescan](https://github.com/lyndsey-ferguson/fastlane_plugins/tree/master/fastlane-plugin-setup_fragile_tests_for_rescan) so that one can rerun flaky tests on CI server and aggregate the results. 

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
