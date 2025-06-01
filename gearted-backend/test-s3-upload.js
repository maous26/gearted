const AWS = require('aws-sdk');
require('dotenv').config();

// Configuration S3
const s3 = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY,
  secretAccessKey: process.env.AWS_SECRET_KEY,
  region: 'eu-north-1'
});

// Test d'upload
async function testUpload() {
  try {
    const params = {
      Bucket: 'gearted-images',
      Key: 'test-from-nodejs.txt',
      Body: 'Test upload depuis Node.js pour Gearted!',
      ContentType: 'text/plain',
      ACL: 'public-read'
    };
    
    const result = await s3.upload(params).promise();
    console.log('✅ Upload réussi!');
    console.log('URL:', result.Location);
    
    // Lister les fichiers
    const listParams = { Bucket: 'gearted-images' };
    const files = await s3.listObjectsV2(listParams).promise();
    console.log('\n📁 Fichiers dans le bucket:');
    files.Contents.forEach(file => {
      console.log(`- ${file.Key} (${file.Size} bytes)`);
    });
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
  }
}

testUpload();
