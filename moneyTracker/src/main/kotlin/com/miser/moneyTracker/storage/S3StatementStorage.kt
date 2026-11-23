package com.miser.moneyTracker.storage

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.stereotype.Component
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.core.sync.RequestBody
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.NoSuchBucketException
import software.amazon.awssdk.services.s3.model.ServerSideEncryption
import java.net.URI

/**
 * S3-compatible object storage: MinIO when self-hosting, Amazon S3 in AWS.
 * Set an endpoint for MinIO; leave it blank for AWS. Without explicit keys the
 * AWS default credential chain (instance role, env) is used.
 */
@Component
@ConditionalOnProperty(name = ["app.storage.type"], havingValue = "s3")
class S3StatementStorage(
    @Value("\${app.storage.s3.bucket}") private val bucket: String,
    @Value("\${app.storage.s3.endpoint:}") endpoint: String,
    @Value("\${app.storage.s3.region:us-east-1}") region: String,
    @Value("\${app.storage.s3.access-key:}") accessKey: String,
    @Value("\${app.storage.s3.secret-key:}") secretKey: String,
    @Value("\${app.storage.s3.create-bucket:false}") createBucket: Boolean,
    // MinIO does not support SSE-S3 without a KMS; AWS S3 encrypts with it.
    @Value("\${app.storage.s3.server-side-encryption:true}") private val sse: Boolean,
) : StatementStorage {

    private val log = LoggerFactory.getLogger(javaClass)

    private val client: S3Client = S3Client.builder()
        .region(Region.of(region))
        .credentialsProvider(
            if (accessKey.isNotBlank()) StaticCredentialsProvider.create(AwsBasicCredentials.create(accessKey, secretKey))
            else DefaultCredentialsProvider.builder().build()
        )
        .apply { if (endpoint.isNotBlank()) endpointOverride(URI.create(endpoint)).forcePathStyle(true) }
        .build()

    init {
        if (createBucket) ensureBucket()
    }

    private fun ensureBucket() {
        try {
            client.headBucket { it.bucket(bucket) }
        } catch (e: NoSuchBucketException) {
            log.info("Creating statement bucket {}", bucket)
            client.createBucket { it.bucket(bucket) }
        }
    }

    override fun store(userId: Long, filename: String?, content: ByteArray, contentType: String?): String {
        val key = storageKey(userId, filename)
        client.putObject({
            it.bucket(bucket).key(key).contentType(contentType ?: "application/octet-stream")
            if (sse) it.serverSideEncryption(ServerSideEncryption.AES256)
        }, RequestBody.fromBytes(content))
        return key
    }

    override fun load(key: String): ByteArray =
        client.getObjectAsBytes { it.bucket(bucket).key(key) }.asByteArray()

    override fun delete(key: String) {
        client.deleteObject { it.bucket(bucket).key(key) }
    }
}
