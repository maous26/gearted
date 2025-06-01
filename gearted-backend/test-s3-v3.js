import { S3Client, ListObjectsV2Command, PutObjectCommand } from '@aws-sdk/client-s3';
import { Upload } from '@aws-sdk/lib-storage';
import dotenv from 'dotenv';

dotenv.config();

// Configuration S3 Client v3
const s3Client = new S3Client({
  region: 'eu-north-1',
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY,
    secretAccessKey: process.env.AWS_SECRET_KEY
  }
});

// Test d'upload
async function testUpload() {
  try {
    // Upload simple
    const uploadParams = {
      Bucket: 'gearted-images',
      Key: 'test-from-nodejs-v3.txt',
      Body: 'Test upload avec AWS SDK v3 pour Gearted!',
      ContentType: 'text/plain'
    };
    
    const result = await s3Client.send(new PutObjectCommand(uploadParams));
    console.log('✅ Upload réussi avec SDK v3!');
    
    // Lister les fichiers
    const listCommand = new ListObjectsV2Command({ Bucket: 'gearted-images' });
    const files = await s3Client.send(listCommand);
    
    console.log('\n📁 Fichiers dans le bucket:');
    if (files.Contents) {
      files.Contents.forEach(file => {
        console.log(`- ${file.Key} (${file.Size} bytes)`);
      });
    }
    
    // URL publique
    console.log('\nURL publique:');
    console.log(`https://gearted-images.s3.eu-north-1.amazonaws.com/${uploadParams.Key}`);
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
  }
}

testUpload();
