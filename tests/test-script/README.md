At the moment just a script to a msg on the queue at the front of the module (dev-tre-parse-judgment-in - get the url,
not the arn and use it as a param (sqs_url) to the script along with bucket (s3_bucket_source) for and name of docx
object (s3_object_bagit) and then aws profiles for that source (aws_profile_source) and for the target of the
queue (aws_profile_target)

The sqs-msg.json has the presigned url for the doxc and a fresh uuid substituted into it before it is put on the queue
at the front of this module.

All still wip & to evolve into a more paramaterised script / a test but may help on other modules with dev.
